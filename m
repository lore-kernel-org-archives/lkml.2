Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965770Ab0GSSzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:55:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64190 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965204Ab0GSSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=B5cN2lD0i247boLTRg4SZODuRSh+EOtmJm3/3FoezdG0erDePJf21fLmHBLjCT9e3/
         utwh4J75SpNsr4o04sCwG4VBmk/Fp21X38Zcq3dzyMDW8pOBDEW4nzP73c2S1tJLtBQ5
         lhV0PtLBRhTqTmCrVBRpy/h9ZzpXuIY0uzDiA=
MIME-Version: 1.0
In-Reply-To: <1279555620.2156.8538.camel@tng>
References: <1279555620.2156.8538.camel@tng>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 19 Jul 2010 11:54:43 -0700
Message-ID: <AANLkTikh5vAYIMMIbyMTfnh_SKr7AlOC9yZipHzzNhlW@mail.gmail.com>
Subject: Re: Existing netlink kernel <--> kernel communication
To: Patrick McManus <mcmanus@ducksong.com>
Cc: Kevin Hayes <kevin@atheros.com>, Marcel Holtmann <marcel@holtmann.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>, linux-kernel@vger.kernel.org,
        Dan Tian <Dan.Tian@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 9:07 AM, Patrick McManus <mcmanus@ducksong.com> wrote:
> Hi Luis,
>
> I'm following up to a linux kernel post of yours back in December:
>
> http://marc.info/?l=linux-kernel&m=125053428528207&w=3
>
> Basically, I have the same interest - an internal netlink client to the
> qdisc interfaces.. I was wondering if you made any progress on the topic
> you could share? It seems maddening that netlink is promoted as an
> intra-kernel mechanism but it is non-obvious how to write a client..

The reason we at Atheros were considering it was a possible way to
communicate between two different subsystems, in our case Bluetooth
and 802.11. While it is technically possible to use netlink for such
purposes it introduces a layer of complexity which can be avoided by
just using direct exported routines, and by coordinating between the
two subsystems you need communication with.

So, the real question I think is why do you need a rigid API ? If
there is a good need, perhaps its a good idea, but so far I guess no
one simply has come up with one.

  Luis
