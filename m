Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2C2QWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:22:06 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:35121 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751845Ab2C2QV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:21:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:Reply-To:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=fRS9hdM+87dxlBCiaN/LN7L4e3yHgAnOmBUIy7ccX9dA7RP+VQJkdNkfNJwHq4wK4CDmA9nWuKFecmhBS41gSoOwMddwKnO3acN4dMBA0lTAB2UG2SjAbZ6uE8+lprbe;
Message-ID: <9da9c271a7fa887aaa66821a49534a53.squirrel@webmail.firszt.eu>
In-Reply-To: <4F748B5B.9010104@xenotime.net>
References: <20120329144217.6cacd2f040fa9abb9190ae1e@canb.auug.org.au>
    <4F748B5B.9010104@xenotime.net>
Date: Thu, 29 Mar 2012 17:21:53 +0100
Subject: Re: [PATCH -next] hid: fix WACOM Kconfig warning
From: "Przemo Firszt" <przemo@firszt.eu>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        "LKML" <linux-kernel@vger.kernel.org>, "Jiri Kosina" <jkosina@suse.cz>,
        linux-input@vger.kernel.org
Reply-To: przemo@firszt.eu
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dnia 29 Marca 2012, 5:18 pm, Cz, Randy Dunlap napisa³(a):
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix hid Kconfig warning:
>
> drivers/hid/Kconfig:595:error: recursive dependency detected!
> drivers/hid/Kconfig:595:	symbol HID_WACOM depends on HID_WACOM
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/hid/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
>
> --- linux-next-20120329.orig/drivers/hid/Kconfig
> +++ linux-next-20120329/drivers/hid/Kconfig
> @@ -595,7 +595,6 @@ config THRUSTMASTER_FF
>  config HID_WACOM
>  	tristate "Wacom Bluetooth devices support"
>  	depends on BT_HIDP
> -	depends on HID_WACOM
>  	select POWER_SUPPLY
>  	---help---
>  	Support for Wacom Graphire Bluetooth and Intuos4 WL tablets.
> --
Thanks!

http://article.gmane.org/gmane.linux.kernel.input/24250

-- 
Regards,
Przemo Firszt

