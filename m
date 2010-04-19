Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0DSBOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 21:14:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54617 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab0DSBOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 21:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iopyTRNMg/sVsqhfHvBAqVhKTh8nRvZnmuZbjlrf9ORIYBG7uk2fQO9LLJNYxHQQXi
         JSQID7n7ChhVS3sp4CqBen0BHTwAiQc1Zk8ZKVynRwkgI2YybxReUHVO+UTZrIZ13/kH
         2Gu+9DOxVANHN9nSzW4mUPsSSJu/ovnrRtm3g=
MIME-Version: 1.0
In-Reply-To: <w2n9c9fda241004170006n53b08bb7y18d59de7e0f631dc@mail.gmail.com>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
	 <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com>
	 <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
	 <63386a3d1003250820x3cf81000i9d27e95c755b9ca8@mail.gmail.com>
	 <k2q1b68c6791003312234qe5da41e7oa1a0c7f535dbb179@mail.gmail.com>
	 <t2t63386a3d1004011623m43212bb4z4dde424b30e3d184@mail.gmail.com>
	 <g2m1b68c6791004011838r2bcde1amd475c225604883e9@mail.gmail.com>
	 <w2n9c9fda241004170006n53b08bb7y18d59de7e0f631dc@mail.gmail.com>
Date: Mon, 19 Apr 2010 10:14:17 +0900
Message-ID: <z2l1b68c6791004181814oe758db7ag513ddefdebf8db1a@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Joonyoung Shim <jy0922.shim@samsung.com>, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>, dan.j.williams@intel.com,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 4:06 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> If there's no comments. it's time to select to merge it.
> I think it can't which is better. so I hope community select any one
> Only consideration which is proper for linux and future usage
As i said, I am working full time on it.
PL330 core and S3C DMA API driver is done and it'll be a day or two
before I am done testing them.
So, around this wednesday I plan to submit patches for PL330 core driver
and the S3C-DMA-API driver for S5P-6442, C1XX and V210
Once the PL330 core is accepted, we can freeze it's API and start work on
DMA engine API driver for it.
