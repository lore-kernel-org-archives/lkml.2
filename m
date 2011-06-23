Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1FWGQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:16:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1FWGQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Bev3wpCwmtZUULJkBfTx7G9wN3TvaB034Cxdz3btfKVv8jlaUa547l0pBEza74tWxN
         W6ZgPziYMBXjRasrquwzo0pEQ1pXGzBGmI1gq9gW9dAhHNFit8gas/3jYm+3Mks/Ssg7
         Tgj9SoggTU6zuYxAJRHdgZ1xiIfGgzxI4aHpE=
MIME-Version: 1.0
In-Reply-To: <1308032369-1615-1-git-send-email-ratbert.chuang@gmail.com>
References: <1308032369-1615-1-git-send-email-ratbert.chuang@gmail.com>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 23 Jun 2011 14:16:27 +0800
Message-ID: <BANLkTim=xdGKaCg0HzirYX5zs1TQn7Gu_g@mail.gmail.com>
Subject: Re: [PATCH] i2c: add Faraday FTIIC010 I2C controller support
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org, ben-linux@fluff.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Tue, Jun 14, 2011 at 2:19 PM, Po-Yu Chuang <ratbert.chuang@gmail.com> wrote:
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>
> Support for Faraday FTIIC010 I2C controller. It is used on
> Faraday A320, A369 and some other ARM SoC's.
>
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> ---
>  drivers/i2c/busses/Kconfig        |    7 +
>  drivers/i2c/busses/Makefile       |    1 +
>  drivers/i2c/busses/i2c-ftiic010.c |  434 +++++++++++++++++++++++++++++++++++++
>  drivers/i2c/busses/i2c-ftiic010.h |  155 +++++++++++++
>  4 files changed, 597 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-ftiic010.c
>  create mode 100644 drivers/i2c/busses/i2c-ftiic010.h

Any comments are appreciated.

Best regards,
Po-Yu Chuang
