Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0G1NqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:46:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:52005 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0G1NqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:46:10 -0400
Message-ID: <4C50349F.7020002@suse.de>
Date: Wed, 28 Jul 2010 15:46:07 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
References: <4C5033D9.7030800@kernel.org>
In-Reply-To: <4C5033D9.7030800@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 03:42 PM, Tejun Heo wrote:
> Hello, Thomas.
> 
> With Jeff's acks added, patches to make libata use irq-expect are
> commited.  Please pull from the following branch to receive patches[1]
> to improve lost/spurious irq handling.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git lost-spurious-irq

I'll ask Stephen to pull the above branch into linux-next until it
shows up via tip so that we don't lose any more linux-next testing
time.

Thank you.

-- 
tejun
