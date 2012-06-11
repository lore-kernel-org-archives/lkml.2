Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2FKOO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:14:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2FKOOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:14:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 11/14] ARM: LPC32xx: DTS adjustment for using pl18x primecell
Date: Mon, 11 Jun 2012 14:14:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
References: <1339412537-24485-1-git-send-email-stigge@antcom.de> <1339412537-24485-12-git-send-email-stigge@antcom.de>
In-Reply-To: <1339412537-24485-12-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111414.14264.arnd@arndb.de>
X-Provags-ID: V02:K0:vaPwxHPixB67QP8ig/8250nyiKxnBxQp7AWeVR2mMBt
 hxZxFh0JSQRfGsUu6ppvt1fA6tCtvQxnleCD01w0v+tR9u3vL5
 tinEeW80UfMijmac48tdyOoAZVi5HqS7eh8jw0Lz/Q8RtSVELe
 Mh2U2QIua3j7T8lRqw09SZ0qNB6MKNrjFPm7FYLGA49P3xNXbG
 8BzFD7Twyev75ntmm7sezBGCz17eLmCpMWsG3lhZnc4yxG7JVt
 TP7YurMqO6KXLPf0PkvN/SnxwZc5hR/eKe2UvaZ+4l10DWGILC
 rbR3XVldwMXs8bXkrWyKzj7naD5NT7a93tHZRwag/t8hXBmnKo
 R/CD0F6brwzq6yQkbiOE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Roland Stigge wrote:
>                         sd@20098000 {
> -                               compatible = "arm,pl180", "arm,primecell";
> +                               compatible = "arm,pl18x", "arm,primecell";
>                                 reg = <0x20098000 0x1000>;
>                                 interrupts = <0x0f 0>, <0x0d 0>;
> +                               status = "disable";
>                         };
>  

The proper way to write this is 'status = "disabled";', with a 'd' at
the end.

	Arnd
