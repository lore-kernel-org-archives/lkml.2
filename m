Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2KAJUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:20:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab2KAJUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:20:13 -0400
Date: Thu, 1 Nov 2012 10:20:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>  <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>  <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, James Bottomley wrote:

> The point I'm making is that given that the majority of exploits will 
> already be able to execute arbitrary code in-kernel, there's not much 
> point trying to consider features like this as attacker prevention.  We 
> should really be focusing on discussing why we'd want to prevent a 
> legitimate local root from writing to the suspend partition in a secure 
> boot environment.

Well, this is being repeated over and over again when talking about secure 
boot, right?

My understanding is that we are not trying to protect against root 
exploiting the kernel. We are trying to protect against root tampering 
with the kernel code and data through legitimate use of kernel-provided 
facilitiies (/dev/mem, ioperm, reprogramming devices to DMA to arbitrary 
memory locations, resuming from hibernation image that has been tampered 
with, etc).

Or perhaps I just misunderstood the point you were trying to make?

Thanks,

-- 
Jiri Kosina
SUSE Labs
