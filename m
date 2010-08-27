Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0H0TJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:09:10 -0400
Received: from smtp2b.orange.fr ([80.12.242.146]:15651 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0H0TJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:09:09 -0400
X-ME-UUID: 20100827190907248.3C99D7000B6E@mwinf2b21.orange.fr
X-ME-User-Auth: eric.valette6
Message-ID: <4C780D52.4080108@free.fr>
Date: Fri, 27 Aug 2010 21:09:06 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100821 Iceowl/1.0b2 Icedove/3.1.2
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: Phil Turmel <philip@turmel.org>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
References: <4C728790.7050805@Free.fr> <4C72EE8F.3040708@turmel.org> <4C768919.30104@Free.fr> <4C76C641.30901@turmel.org> <4C77A89A.3070906@Free.fr> <20100827163753.GA13252@citd.de>
In-Reply-To: <20100827163753.GA13252@citd.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2010 18:37, Matthias Schniedermeyer wrote:

> I don't really get what you mean.
> But binary duplication isn't the issue, source-code duplication is.
> I'd count an initramfs to the binary category. It is "compiled" more or
> less literaly.

binary duplication is a waste of space (SSD are'nt cheap) and time. 
Plus, you have a real duplication for the fs-search in grub/lilo/add 
your favorite evolved boot loader there.

>> 	3) The tmpdevfs is also a dupplicate somehow
>
> No.
>
> devtmpfs uses tmpfs or ramfs as backing-store. And it doesn't really
> duplicate udev either, as it only does the bare minimum needed to get
> the computer to the point where udev can do the rest. Like when you have
> a root filesystem with no /dev at all.

I know. But It could do just a bit more find creating the 
/dev/disk/by-uuid/foo where foo is the one given ib root=UUID=foo


--eric




