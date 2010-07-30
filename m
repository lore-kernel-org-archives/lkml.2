Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0G3JqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:46:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab0G3JqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:46:01 -0400
Message-ID: <4C529F59.3020404@suse.de>
Date: Fri, 30 Jul 2010 11:46:01 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/29/2010 10:44 AM, Thomas Gleixner wrote:
>> I'll ask Stephen to pull the above branch into linux-next until it
>> shows up via tip so that we don't lose any more linux-next testing
>> time.
> 
> I'm working on it already and I'm currently twisting my brain around
> the problem this patches will impose to the RT stuff, where we cannot
> access timer_list timers from atomic regions :(

Oh, I see.  A dull last ditch solution would be just disabling it on
CONFIG_PREEMPT_RT, but yeah that will be dull.  :-(

Thanks.

-- 
tejun
