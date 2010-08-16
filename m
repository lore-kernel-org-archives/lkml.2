Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0HPTXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:23:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41725 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0HPTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=pocgPq5WRdjm/kiGQx6r2p5bMON6QgjmgmskKg+uSkUm9QYLCpxxe/pnW7rLNqEBbc
         u1WvoVS6i1FT7MNx7BZM7A8TnIOxiWDPsvU9aGzodK7D4442/1YERGfkgaqWwnLwDPBN
         sfebCXFh2gGzoIzBvNwv1sBZhj4in8PdHLP0Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] pata_winbond: fix module init
Date: Mon, 16 Aug 2010 21:23:03 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
References: <20100803152549.GQ26313@bicker>
In-Reply-To: <20100803152549.GQ26313@bicker>
MIME-Version: 1.0
Message-Id: <201008162123.03208.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dan,

On Tuesday 03 August 2010 05:27:47 pm Dan Carpenter wrote:
> winbond_init_one() returns 0 on success and an error code on failure.
> In the original code, we always just released the regions and return
> -ENODEV.  This was introduce in 2006 by 7e45b0e5f6f6 "[PATCH] libata:
> Winbond support".

You might like to pick up

	http://patchwork.ozlabs.org/patch/39358/

instead..

Thanks.
--
Bartlomiej Zolnierkiewicz
