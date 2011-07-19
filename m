Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1GSGzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:55:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54781 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1GSGzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:55:03 -0400
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org
In-Reply-To: <4E25221F.6060605@redhat.com>
References: <1310987909-3129-1-git-send-email-amwang@redhat.com>
	 <20110718135243.GA5349@suse.de>  <4E25221F.6060605@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 08:54:58 +0200
Message-ID: <1311058498.16961.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 19 juillet 2011 à 14:20 +0800, Cong Wang a écrit :

> Hmm, since we don't have to enable SYSFS for NUMA, how about
> make a new Kconfig for drivers/base/node.c? I.e., CONFIG_NUMA_SYSFS,
> like patch below.
> 

I dont quite understand this patch, nor the idea behind it.

You can have a NUMA kernel (for appropriate percpu locality or whatever
kernel data), and yet user land processes unable to use numactl if SYSFS
is not enabled. I dont see a problem.

Please just fix the link problem ?



