Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3AARYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 12:24:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42223 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab3AARYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 12:24:11 -0500
Message-ID: <50E31BB4.7040702@zytor.com>
Date: Tue, 01 Jan 2013 09:24:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shea Levy <shea@shealevy.com>
CC: linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Revisiting EFI boot stub config file support
References: <50E306FB.6080607@shealevy.com>
In-Reply-To: <50E306FB.6080607@shealevy.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2013 07:55 AM, Shea Levy wrote:
> Hi all,
> 
> In March last year, I submitted a patch to enable the EFI boot stub to
> read its config arguments from a file on the ESP, both to help with
> booting from livecds and to avoid having to use efibootmgr every time
> you change your boottime arguments. I ended up dropping the submission
> because I ended up coming to the conclusion that tools like rEFInd and
> gummiboot were better suited to the task of boot managing than the
> kernel itself.
> 
> Since then, however, I've received enough emails asking about the status
> of the patch that I think there is room for a simpler entrant into the
> field of linux EFI boot management. This could be in-kernel, as per my
> original patch, or a very simple out-of-kernel (but maybe distributed
> in-tree?) efi image that simply reads linux.conf and boots linux with
> those parameters. My personal bias is still toward handling this
> functionality outside of the kernel itself, but before I started the
> work I thought I'd ask here if anyone thought I should instead bring my
> old patch up-to-date.
> 

I am willing to accept this (but I am not the first-line maintainer,
Matt is) in the kernel EFI stub as long as there are no hard-coded
filenames involved, no automatic behavior, and no "scanning".  Those are
showstoppers, as is adding to the boot time for nonusers.

	-hpa


