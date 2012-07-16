Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2GPGUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:20:16 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34298 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2GPGUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:20:14 -0400
MIME-Version: 1.0
In-Reply-To: <50032F24.8050903@landley.net>
References: <CALbm-EbggDYBwEDmo6bjEO_=p0YEmLHASNkfAN5J-P4-mT-vgg@mail.gmail.com>
	<CAFtxgO5=oANwXJ34rkKjWFiOxgB1hvEDToZXt=9w5gKoVOsOBw@mail.gmail.com>
	<CALbm-EY-4iQy3HYi4bYdLVsLyr+iDecTUsVt43+_Nf9v_rkTyw@mail.gmail.com>
	<50032F24.8050903@landley.net>
Date: Mon, 16 Jul 2012 08:20:13 +0200
Message-ID: <CALbm-EbZg+BtW+BTokA2Xz+P1DSt3-WR+xV5DB_GrieLqR27NA@mail.gmail.com>
Subject: Re: [PATCH] Rewrite Documentation/SubmittingPatches.
From: Stefan Beller <stefanbeller@googlemail.com>
To: Rob Landley <rob@landley.net>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heh,
It seems as if googlemail is not a suited interface to contribute to linux.

The raw patch (without clipped lines) can be found at
http://pastebin.com/raw.php?i=3QKRZz2M

Stefan

2012/7/15 Rob Landley <rob@landley.net>:
> On 07/13/2012 09:45 AM, Stefan Beller wrote:
>> This updates the documentation on how to create patches and send
>> these to the kernel mailing list.
>>
>> The documentation before was written in times before git was there,
>> so the crafting of the patch needed to be done manually by diff -up
>> in the right directory.
>>
>> This patch aims at simplifying the patch sending process, without
>> breaking the output results.
>
> This patch is whitespace damaged (wordwrapped at the @@ lines), which is
> either ironic or unfortunate. (After Alanis Morisette, I can't tell
> anymore.)
>
>> A discussion can be found at
>> https://plus.google.com/111049168280159033135/posts/ekAxK9achsA
>>
>> Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
>> Acked-by: Jeff Garzik jgarzik@pobox.com
>
> But other than that Jeff's objection was my big one, and that's
> addressed in v2, so:
>
> Acked-by: Rob Landley <rob@landley.net>
>
> Rob
> --
> GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
> Either it's "mere aggregation", or a license violation.  Pick one.
