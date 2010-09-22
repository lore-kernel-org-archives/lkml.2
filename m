Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab0IVWZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:25:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55323 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0IVWZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gV+vp0q3loUUxbzJ4z8iI2kCoSx1pkNVWMgKQAmPknGMixRPK1OdCsgfITkrGpKZ/1
         4bGLborhBwVVXOH/FbKhrdR9IncexXoJ3soRFqHN/fx+DVXVFdpUzMXtdcnr68QGzcOB
         rzGMkV8lqUNtV8xjOuYgKehvWVco3lJrMdS6s=
MIME-Version: 1.0
In-Reply-To: <AANLkTin2hdoDkGTHZxBEb1bLwTcQmzFeAi1dKKo53oJC@mail.gmail.com>
References: <1281355646-12941-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTikt_GNsswb+EaCTeX=-9oh_+g7XhLA94Gy24kSZ@mail.gmail.com>
	<AANLkTin2hdoDkGTHZxBEb1bLwTcQmzFeAi1dKKo53oJC@mail.gmail.com>
Date: Wed, 22 Sep 2010 15:25:41 -0700
X-Google-Sender-Auth: VDqUznojzh79fDmPq0VckTjt8h0
Message-ID: <AANLkTimN192Y1am88PuXV+_HC--GuM=UC4kq9SaL-ED_@mail.gmail.com>
Subject: Re: [PATCH 00/14] DMAENGINE: ste_dma40: bugfixes and enhancements
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 3:02 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Aug 25, 2010 at 10:19 AM, Linus Walleij
> <linus.ml.walleij@gmail.com> wrote:
>> 2010/8/9 Linus Walleij <linus.walleij@stericsson.com>:
>>
>>> This patch series adds a few bugfixes and some enhancements to the
>>> DMA40 driver. Most should be pretty straight forward, others are
>>> more elaborate, like the amendments to extend hw job lists at
>>> runtime if there is already a queued job.
>>
>> Dan, can these be queued for -next? Shouldn't be any controversial
>> stuff in them AFAICT.
>
> Yes, consider them acked-by and on their way to -next.  I've been
> preparing for the birth of my daughter who finally arrived on
> Wednesday!  So expect intermittent attention to drivers/dma/ through
> the middle of September.  I do plan to get this pushed before then,
> and catch up on the i.mx sdma discussion.
>
> Thanks for your review, and patience,
>

Applied to the dma40 branch and will show up in next shortly.  Given
the increasing patch volume I have decided to maintain stable topic
branches and turn the the async_tx.git#next branch into a snapshot
merge of these topics.

--
Dan
