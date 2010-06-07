Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0FGTLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab0FGTLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:11:17 -0400
Date: Mon, 7 Jun 2010 15:11:07 -0400
From: Dave Jones <davej@redhat.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: 2.6.35-rc2-git1 - BUG: using smp_processor_id() in preemptible
 [00000000] code: ondemand/4323
Message-ID: <20100607191107.GA4799@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Miles Lane <miles.lane@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>
References: <AANLkTim_9zeeOJbg0UTU8Wm7u7yFhFNACZ2hlnL3GMFz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim_9zeeOJbg0UTU8Wm7u7yFhFNACZ2hlnL3GMFz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 03:02:58PM -0400, Miles Lane wrote:
 > [   90.531089] BUG: using smp_processor_id() in preemptible [00000000]
 > code: ondemand/4323
 > [   90.531100] caller is nr_iowait_cpu+0x15/0x2c
 > [   90.531106] Pid: 4323, comm: ondemand Tainted: G        W
 
arjan is looking into this.
probably just needs some preempt disable/enable calls.

	Dave

