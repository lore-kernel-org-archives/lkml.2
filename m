Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1ATJkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:40:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58386 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab1ATJj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=YaKniQfJZzuWyzjOylvE+IB9WC/wb+jlMPgUAKBL8STsfvbazg38hn17hJJup9Lzl+
         5uycg30Bj8DlfMUU4BUKn3LKYw1ecAUPAD56/421tTDwyOUTtXDfcnMOATFmgLnp31k+
         ZhoGGZ/iyoLBsmonk3HH0aG7Bha3IiRYj9vg0=
MIME-Version: 1.0
In-Reply-To: <4D373791.5050000@infradead.org>
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
 <20110111112434.GE2385@legolas.emea.dhcp.ti.com> <AANLkTi=TF9uYEv2Y3qwMKham=K2cCxo4UOTn8Vf+S-KC@mail.gmail.com>
 <AANLkTimRLGYugF+2=-nFvLeXdnLOy8Morx_wxzVTt9w5@mail.gmail.com>
 <5fc7c1cdc4aed93c1dbe7a3d1916bb1c.squirrel@webmail.xs4all.nl>
 <AANLkTikRDWF5fyqixbJs+DRJN=aJGmgqmQOdVL_d9tPo@mail.gmail.com> <4D373791.5050000@infradead.org>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Thu, 20 Jan 2011 15:09:35 +0530
X-Google-Sender-Auth: rF2aCF9-BCBqmvdn6jgZMdJa8sU
Message-ID: <AANLkTinonWy9PqXmE3XawOcQMDjM94K18z4NCUqac=e7@mail.gmail.com>
Subject: Re: [RFC V10 3/7] drivers:media:radio: wl128x: FM Driver Common sources
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

We don't maintain a separate tree for these v4l2 drivers. We generally
use the linux-omap tree for our day to day activities, However the
drivers posted here has also been tested on the linux-2.6.37-rc7,
So it is directly applicable on the k.org tree.

So, I was hoping you can merge these patches on the v4l2 tree on the
kernel.org and thereby it gets pulled into the mainline, when linus
would pull your tree.

It would also help for us for it to be on v4l2 tree, since it would
mean you and Hans have also reviewed it :).

Regards
Manjunatha Halli



On Thu, Jan 20, 2011 at 12:42 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Manju,
>
> Em 18-01-2011 11:19, halli manjunatha escreveu:
>>  have a look at the driver it’s already reviewed by Hans Verkuil.
>> Please let me know if you are okay to include this in mainline.
>
> As I've already pointed you, just send me a pull request from your tree when
> you think it is ready. I'll be reviewing it after that. There are just too much
> reviews on those drivers from TI for me to dig into every single version, especially
> since, on most cases, I can't really contribute much, as I don't have OMAP3/Davinci
> datasheets and the required devices here for testing, and that the reviews
> come from someone at TI and/or one of your customers with a real test case
> scenario.
>
> So, as agreed in the past, I just mark all those drivers with RFC at patchwork
> and I wait for the driver maintainer to send me a pull request, indicating me
> that you've reached on a point where the driver/patch series is ready for its
> addition.
>
> So, if you think you're ready, you just need to send a pull request to the ML.
> You don't even need to c/c me on that (and please avoid doing it, otherwise
> I end by having multiple copies of your pull request, flooding my email with no
> good reason).
>
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards
Halli
