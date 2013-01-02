Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3ABRya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:54:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48982 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3ABRy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:54:27 -0500
Date: Wed, 2 Jan 2013 17:54:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Shea Levy <shea@shealevy.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Revisiting EFI boot stub config file support
Message-ID: <20130102175423.GA2881@srcf.ucam.org>
References: <50E306FB.6080607@shealevy.com>
 <50E31BB4.7040702@zytor.com>
 <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com>
 <20130102174319.GA2590@srcf.ucam.org>
 <4DA0AD0B-49D1-4938-B38D-A15C378167B0@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA0AD0B-49D1-4938-B38D-A15C378167B0@shealevy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 12:52:21PM -0500, Shea Levy wrote:

> But you can't set args when booting from external media (using e.g. 
> \boot\efi\bootx64.efi), at least not on any system I've seen. And even 
> if you could, that'd over complicate the install process for new 
> users.

So have an initial wrapper that launches the kernel and passes an 
argument. You're going to need something equivalent if you want to 
support Secure Boot.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
