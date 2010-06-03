Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0FCI45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:56:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54912 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab0FCI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UbeRJPBBcIcXwhWzKzlLQDvss0Nx4wkm/V4Fsf6toynahm5ShiVsaq8KgMyI9GXNkt
         kI3Xhis3MFzexkJeB8AmMP+8Ldczs/rJbmpQLhSStCTlZv8y+pNYiFFUaOE58ly+vDPI
         rr3bDQFKHhj7zKlSwKsBHg+Nbb4HSon6kNw20=
MIME-Version: 1.0
In-Reply-To: <20100603084104.GA17431@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
	<20100603075402.GA11093@oksana.dev.rtsoft.ru>
	<AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
	<20100603084104.GA17431@oksana.dev.rtsoft.ru>
Date: Thu, 3 Jun 2010 16:56:54 +0800
Message-ID: <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
Subject: Re: 2.6.25-rc1 ahci regression
From: Luming Yu <luming.yu@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> So, I wonder, have you actually bisected the thing correctly?

That is possible,

But git-bisecting just takes too much times even in any modern
hardware with reasonable configurations

I  git-archive --format=tar  365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef
tree and  then reverted the patch gotten from "git show
365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef"

then it boots,  otherwise not boot.
