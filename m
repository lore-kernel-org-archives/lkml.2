Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2JHPRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:17:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43399 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab2JHPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:17:28 -0400
MIME-Version: 1.0
In-Reply-To: <1349690974.15966.113.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CACx33gg6Hmh8E0Mv5TLdi5ufZcppHMws8XAdfaThF_Y2QBb5vA@mail.gmail.com>
	<1349690974.15966.113.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Mon, 8 Oct 2012 21:17:27 +0600
Message-ID: <CACx33ghsnYz0VNwEbhuyn7ZgrtamHfrTKHR4E0b9Q+LpahcDXw@mail.gmail.com>
Subject: Re: boot failure on i7-3317u in Samsung 900x3c
From: Mike Bakhterev <mike.bakhterev@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 4:09 PM, Matt Fleming <matt@console-pimps.org> wrote:
>
> We've seen things like this before on Samsung laptops,
>
>         https://bugzilla.kernel.org/show_bug.cgi?id=47121
>
> We attributed it to a buggy UEFI implementation.
>

Thanks for the link. But what kind of bug this could be? And could it
be worked around? How can i help?

> So both Windows 7 and 8 boot successfully on your new laptop, but every
> OS failed with the *same* MCE error on your first? That is interesting.
>

No. Windows-es didn't report any errors. The machine just broke
someday when Windows 8 booted. Different Linux kernels fail with the
same MCE. The same MCE rises sometimes (frequently, but not always)
when i'm trying to write something to /sys entry for keyboard
backlight or to rfkill bluetooth phy.

> Does anyone have a clue how to diagnose this further? I still think it's
> a buggy UEFI implementation, especially since it ships with a CSM. Is it
> possible that these MCE errors are non-fatal on Win 7/8?
>

Are there any info on how to decode this MCE code? It is not covered
in Intel's manuals. Hard to reason without any knowledge.

- MB, respectfully
