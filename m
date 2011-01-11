Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1AKBIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:08:45 -0500
Received: from kroah.org ([198.145.64.141]:35034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab1AKBIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:08:37 -0500
Date: Mon, 10 Jan 2011 17:08:27 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 4/4] x86: usb handoff in early_quirk
Message-ID: <20110111010827.GD32585@kroah.com>
References: <4D2A1382.7010407@kernel.org>
 <4D2AC6BF.3010907@kernel.org>
 <4D2BA8FE.9090204@kernel.org>
 <4D2BAA85.9060902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2BAA85.9060902@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 04:55:33PM -0800, Yinghai Lu wrote:
> 
> some systems keep getting
>   APIC calibration not consistent with PM-Timer: 139ms instead of 100ms
>   APIC delta adjusted to PM-Timer: 831249 (1163736)
> 
> USB legacy SMI handler is not disabled at that time.
> 
> Try to disable USB legacy support early with this patch.
> So later APIC Timer calibration don't get messed up by USB legacy support SMI handler.
> After this patch, that warning never show up for 100 reboot tests.

So all of this work was for one warning that really doesn't mean much,
if anything?  That seems very pointless, wouldn't you agree?

Wouldn't it be nicer if the BIOS fixed the SMI code to not have such
problems?

thanks,

greg k-h
