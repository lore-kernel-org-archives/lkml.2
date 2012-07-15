Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2GPDlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 23:41:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51407 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2GPDlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 23:41:15 -0400
Message-ID: <50032F24.8050903@landley.net>
Date: Sun, 15 Jul 2012 15:59:16 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stefan Beller <stefanbeller@googlemail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Rewrite Documentation/SubmittingPatches.
References: <CALbm-EbggDYBwEDmo6bjEO_=p0YEmLHASNkfAN5J-P4-mT-vgg@mail.gmail.com> <CAFtxgO5=oANwXJ34rkKjWFiOxgB1hvEDToZXt=9w5gKoVOsOBw@mail.gmail.com> <CALbm-EY-4iQy3HYi4bYdLVsLyr+iDecTUsVt43+_Nf9v_rkTyw@mail.gmail.com>
In-Reply-To: <CALbm-EY-4iQy3HYi4bYdLVsLyr+iDecTUsVt43+_Nf9v_rkTyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 09:45 AM, Stefan Beller wrote:
> This updates the documentation on how to create patches and send
> these to the kernel mailing list.
> 
> The documentation before was written in times before git was there,
> so the crafting of the patch needed to be done manually by diff -up
> in the right directory.
>
> This patch aims at simplifying the patch sending process, without
> breaking the output results.

This patch is whitespace damaged (wordwrapped at the @@ lines), which is
either ironic or unfortunate. (After Alanis Morisette, I can't tell
anymore.)

> A discussion can be found at
> https://plus.google.com/111049168280159033135/posts/ekAxK9achsA
> 
> Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
> Acked-by: Jeff Garzik jgarzik@pobox.com

But other than that Jeff's objection was my big one, and that's
addressed in v2, so:

Acked-by: Rob Landley <rob@landley.net>

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
