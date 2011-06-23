Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab1FWWu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:50:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62001 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094Ab1FWWuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=LW2atBvLOccb77f8KQXk8nw9OcjGYCuql3bXcVfw6shAvekwZUyMcRZeHcsr019T8a
         kOKNiSprXS18mepm75rt3k6mg+7UbG5h11Fb+Bb9YeZ3Y0jkraeomE6hpLVMWY2OUY6E
         A5Z2cjP34KTBe95svfYtRwHNFENmHZFp5BRpA=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106240009201.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <alpine.LNX.2.00.1106240009201.17688@swampdragon.chaosbits.net>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 23 Jun 2011 18:50:32 -0400
X-Google-Sender-Auth: Hz9LG46St_HCeShwCtCUO0MqRGw
Message-ID: <BANLkTimAJ3XCfhn5REP7dAaqRTxF93V8YA@mail.gmail.com>
Subject: Re: [PATCH 09/37] Remove unneeded version.h includes from drivers/input/
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        device-drivers-devel@blackfin.uclinux.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 18:10, Jesper Juhl wrote:
>  drivers/input/keyboard/adp5588-keys.c |    1 -
>  drivers/input/keyboard/adp5589-keys.c |    1 -
>  drivers/input/misc/bfin_rotary.c      |    1 -

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
