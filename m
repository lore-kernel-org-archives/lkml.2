Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3ABN0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:26:39 -0500
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:59441 "EHLO
	homiemail-a79.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752649Ab3ABN0d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:26:33 -0500
References: <50E306FB.6080607@shealevy.com> <50E31BB4.7040702@zytor.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <50E31BB4.7040702@zytor.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (10A551)
From: Shea Levy <shea@shealevy.com>
Subject: Re: Revisiting EFI boot stub config file support
Date: Wed, 2 Jan 2013 08:26:29 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 1, 2013, at 12:24, "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 01/01/2013 07:55 AM, Shea Levy wrote:
>> Hi all,
>> 
>> In March last year, I submitted a patch to enable the EFI boot stub to
>> read its config arguments from a file on the ESP, both to help with
>> booting from livecds and to avoid having to use efibootmgr every time
>> you change your boottime arguments. I ended up dropping the submission
>> because I ended up coming to the conclusion that tools like rEFInd and
>> gummiboot were better suited to the task of boot managing than the
>> kernel itself.
>> 
>> Since then, however, I've received enough emails asking about the status
>> of the patch that I think there is room for a simpler entrant into the
>> field of linux EFI boot management. This could be in-kernel, as per my
>> original patch, or a very simple out-of-kernel (but maybe distributed
>> in-tree?) efi image that simply reads linux.conf and boots linux with
>> those parameters. My personal bias is still toward handling this
>> functionality outside of the kernel itself, but before I started the
>> work I thought I'd ask here if anyone thought I should instead bring my
>> old patch up-to-date.
> 
> I am willing to accept this (but I am not the first-line maintainer,
> Matt is) in the kernel EFI stub as long as there are no hard-coded
> filenames involved, no automatic behavior, and no "scanning".  Those are
> showstoppers, as is adding to the boot time for nonusers.

Hm, ok. Does the boot stub have access to CONFIG_CMDLINE? Or could another compile-time setting be added so that distros can ship livecds that automatically use a config file found at a hard-coded location?

> 
>    -hpa
> 
> 
