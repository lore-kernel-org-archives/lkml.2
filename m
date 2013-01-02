Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3ABRw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:52:26 -0500
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:60906 "EHLO
	homiemail-a59.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752624Ab3ABRwY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:52:24 -0500
References: <50E306FB.6080607@shealevy.com> <50E31BB4.7040702@zytor.com> <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com> <20130102174319.GA2590@srcf.ucam.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130102174319.GA2590@srcf.ucam.org>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <4DA0AD0B-49D1-4938-B38D-A15C378167B0@shealevy.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (10A551)
From: Shea Levy <shea@shealevy.com>
Subject: Re: Revisiting EFI boot stub config file support
Date: Wed, 2 Jan 2013 12:52:21 -0500
To: Matthew Garrett <mjg59@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2013, at 12:43, Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Jan 02, 2013 at 08:26:29AM -0500, Shea Levy wrote:
> 
>> Hm, ok. Does the boot stub have access to CONFIG_CMDLINE? Or could 
>> another compile-time setting be added so that distros can ship livecds 
>> that automatically use a config file found at a hard-coded location?
> 
> Just pass the config file as the first argument?
> 

But you can't set args when booting from external media (using e.g. \boot\efi\bootx64.efi), at least not on any system I've seen. And even if you could, that'd over complicate the install process for new users.

> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
