Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1EER2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 13:28:18 -0400
Received: from christianhoffmann.info ([88.175.101.52]:37712 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab1EER2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 13:28:17 -0400
Message-ID: <4DC2DE2C.40108@christianhoffmann.info>
Date: Thu, 05 May 2011 19:28:12 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm> <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos> <4DC1832E.5030806@christianhoffmann.info> <alpine.LFD.2.02.1105041931510.3005@ionos> <4DC1AB9B.8080501@christianhoffmann.info> <alpine.LFD.2.02.1105042154410.3005@ionos>
In-Reply-To: <alpine.LFD.2.02.1105042154410.3005@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> So we are back to:
>
> [    0.644189] Calling fixup hook: quirk_usb_early_handoff+0x0/0x4a6
> [  145.936254] Calling fixup hook: pci_fixup_video+0x0/0xac
>
> So we really need to know what's happening there.
>
> Can you please apply the following patch and enable
> CONFIG_FUNCTION_TRACER and add "ftrace=function" on the command line?
>
> When the box is up, mount debugfs (mount -t debugfs debugfs
> /sys/kernel/debug) and read out /sys/kernel/debug/tracing/trace, bzip2
> it and provide it somewhere for download. If you have no way to do
> that, mail it to me offlist.

Hi,

trace can be found here:

http://dl.dropbox.com/u/21820416/hanging_2.6.39-rc6.trace.bz2

Rgds,
Chris
