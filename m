Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966516Ab2EOTNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:13:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965849Ab2EOTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:13:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver
Date: Tue, 15 May 2012 19:13:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, linus.walleij@stericsson.com, linux-sh@vger.kernel.org,
        horms@verge.net.au, grant.likely@secretlab.ca, lethal@linux-sh.org,
        olof@lixom.net
References: <20120511094103.16423.51840.sendpatchset@w520> <201205121318.54115.arnd@arndb.de> <CANqRtoQa8Ewd74d+t0iXPXkmUDan6OjcD5VPwCFpQKcg8KvXbg@mail.gmail.com>
In-Reply-To: <CANqRtoQa8Ewd74d+t0iXPXkmUDan6OjcD5VPwCFpQKcg8KvXbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151913.16372.arnd@arndb.de>
X-Provags-ID: V02:K0:wbt2wuVSWWWVUPCULtekUfemZxUdHD6qXS7f4Yanic7
 g/F4L/nf/cR9XZWFBoLv+PLyiGD+C0DGmkCMVokRyFJ8wNQw0U
 zvDh6zHa7oqDGYFj878vTbJWc7/QwAC83I86YTh+lV4q90q2Hu
 PJbxMdLw0shTy6k0Nr815Apbce9kOcQEIOXrdoyZCXVXiotWng
 9HNo1Uv9IYoDH8+3Q1Vu25WlCaKIJT9YQFbdumDwQQrnuH6766
 964edhtx11CnpS+8+CrPnGl9hmpxh3QyD0et8tFFhjALHTKBXD
 EVi1rQwCCqIR6LNmbRq/2w5JM65hMRDytqYUqe6uHEczT9dzqe
 Kzf3bDiuF2KUtM8Mq4Ek=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2012, Magnus Damm wrote:
> >> > Isn't there a new nice inline that will both request and
> >> > remap a piece of memory?
> >>
> >> If so then that would be excellent. Especially together with
> >> ioread/iowrite so the code can work both for IOMEM and PORT
> >> transparently.
> >
> > We have a bunch of helpers, but I think none that does
> > everything yet. io_iomap() locates and remaps the resource.
> > devm_request_and_ioremap() does the request and the map, but
> > doesn't pull it out of the device.
> 
> Let me know if you see any reason for not doing that. I'd be happy to
> try to cook something up and convert my drivers one by one.

I think it would be good to have it, so I don't mind if you give it
a go, but I fear that a lot of people cna have conflicting ideas on
what the perfect interface looks like ;-)

	Arnd
