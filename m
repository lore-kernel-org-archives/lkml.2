Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0K2CR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:17:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49677 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0K2CRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:17:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=C0+5z1w9k42OZQwNFqYfszGSzhz8RIBdkQ3KTLyRJUfdoLpqduq7dN7h6w71KeyFod
         mqAH8gvq12oVzRjKpPK6cfANxthJ/nZrdE1dAzBufURkkHIe9FVwViCrdZPJgwI2HIdY
         +vUIa7jn+Yn15mjQF1Oif7C4zkyRlxhcl5h4A=
MIME-Version: 1.0
In-Reply-To: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 28 Nov 2010 18:17:33 -0800
X-Google-Sender-Auth: zdsZxl60zfpt3k_hhrfU-57sHuw
Message-ID: <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
Subject: Re: [PATCH wireless-next] ath: Rename ath_print to ath_debug
To: Joe Perches <joe@perches.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 3:53 PM, Joe Perches <joe@perches.com> wrote:
> Make the function name match the function purpose.
> ath_debug is a debug only facility.
> ath_print seems too generic a name for a debug only use.
>
> Removed an unnecessary trailing space in htc_drv_main.c
>
> Signed-off-by: Joe Perches <joe@perches.com>

Nack, I don't see the point.

  Luis
