Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1ITKlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:41:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36562 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1ITKlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:41:09 -0400
Subject: Re: coretemp breaks lockdep. (MAX_LOCKDEP_ENTRIES too low!)
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Rudolf Marek <r.marek@assembler.cz>
Date: Tue, 20 Sep 2011 12:40:47 +0200
In-Reply-To: <20110915193018.GA10256@redhat.com>
References: <20110915193018.GA10256@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316515247.11841.38.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 15:30 -0400, Dave Jones wrote:
> # while true; do rmmod coretemp; modprobe coretemp; done
> 
> 
That's a known 'feature' of lockdep, module usage leaks resources. Just
say no to modules.
