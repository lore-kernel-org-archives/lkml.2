Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0D1Ndr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:33:47 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:54195 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0D1Ndo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DSwdpeZIld1RyJ4bpUWg+aMJtO+Dq2RKFXB9nVUwq1FXBNt3dSh5/Z8CcNEuCgY2XF
         k+jWnX4cnpY9jbewv6QmOgcDPU3tqFHOmWDqAzXXvQlvq+WrW6Z2hSUMXWKtaB5XUgus
         ul7MI+QTq1H0HjEI91DQZ8FoE7/ZPnzcbZLyk=
MIME-Version: 1.0
In-Reply-To: <201004271153.34972.sven.eckelmann@gmx.de>
References: <1272361449-15416-1-git-send-email-reodge@gmail.com>
	 <201004271153.34972.sven.eckelmann@gmx.de>
Date: Wed, 28 Apr 2010 21:33:40 +0800
Message-ID: <p2p90c96c971004280633t1188db65pd1bbe3679adf4d53@mail.gmail.com>
Subject: Re: [PATCH] Staging: batman-adv: fixed comments to maintain 80 char 
	limit
From: Mark Rankilor <reodge@gmail.com>
To: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: gregkh@suse.de, andrew@lunn.ch, lindner_marek@yahoo.de,
       siwu@hrz.tu-chemnitz.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 April 2010 17:53, Sven Eckelmann <sven.eckelmann@gmx.de> wrote:
> Your patch doesn't apply anymore. See
> 1270341625-28764-1-git-send-email-luisbg@ubuntu.com and follow ups [1].

I had a look at the follow ups and saw this one:

https://lists.open-mesh.org/pipermail/b.a.t.m.a.n/2010-April/002483.html

So would it be best if I were to submit patches against the linux-next
tree? Or is it necessary to work against the batman maint or master
trees?

I'd much prefer if I could work against linux-next since if I wanted
to do some work on another staging driver, then I wouldn't have to go
and check out their repository.

Regards,
Mark
