Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1IMGLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 02:11:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48469 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1IMGLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 02:11:15 -0400
Subject: Re: What is the difference between percpu_xxx and this_cpu_xxx?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4E6EDBFB.4010705@intel.com>
References: <4E6EDBFB.4010705@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 08:11:06 +0200
Message-ID: <1315894267.2556.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 septembre 2011 à 12:28 +0800, Huang Ying a écrit :
> Hi,
> 
> If my understanding was correct, from the kernel source code, it appears
> that percpu_xxx and this_cpu_xxx have the same semantics and
> implementation in effect, haven’t them?
> 
> If so, why do we need two API for the same thing?

History mostly, and transition.

percpu_inc() was an x86 only thing

__get_cpu_var(var)++ -> percpu_inc(var) -> this_cpu_inc(var)



