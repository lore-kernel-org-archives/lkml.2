Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1EZFLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:11:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65506 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab1EZFLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:11:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i4AVMAYOhZtBz/yqEXbDTvT+tAuuT+f1TiYmVth76sHe6QusELCJ9hOjx7FXr5EDdd
         hT/cYgLZHFk6HhqiZU+2mU86BXpq2cyNZFx1LORtN3HdJ7By8COQiukLJoTh02YkhMMF
         oX8YVGwdtr9DuRUojvBkcr0C4u+LAO8Ht8Y34=
MIME-Version: 1.0
In-Reply-To: <4DDDD96E.3020604@snapgear.com>
References: <1306314660-19288-1-git-send-email-geert@linux-m68k.org>
	<4DDDD96E.3020604@snapgear.com>
Date: Thu, 26 May 2011 07:11:38 +0200
X-Google-Sender-Auth: ZVYfB-fTBEf8IjEke-TPRRm9lX0
Message-ID: <BANLkTi=QB5Hm8SWFjmYy4FUi0GZXiGC7Ew@mail.gmail.com>
Subject: Re: [PATCH 3/4] m68knommu: Make empty_zero_page "void *", like on m68k
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
        uclinux-dev@uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, May 26, 2011 at 06:39, Greg Ungerer <gerg@snapgear.com> wrote:
> On 25/05/11 19:10, Geert Uytterhoeven wrote:
>> This allows to get rid of the casts.
>>
>> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
>
> Looks good:
>
> Acked-by: Greg Ungerer <gerg@uclinux.org>
>
> Do you want me to add to the m68knommu git tree?
> Or are these part of a series you intend pushing yourself?

Please add it to your tree.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
