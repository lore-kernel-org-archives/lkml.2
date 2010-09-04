Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0IDVYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 17:24:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43225 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0IDVYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 17:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rIYUMrP9oHC1GyqqI19g4Nht9NZ3TVY9Z/EgLUnfxO2+HrGDXlq0+SqojmJXU7KbGP
         kjcL+p6EQGAF3NvS8qRUqKbNwnmsvk+5K1sdwKAmSeL69YuWD44yrq9+sw1dNl8+dV3x
         COXGb+Cu3yY0+M1JveC+UguGEgQe9DNEiE6ew=
MIME-Version: 1.0
In-Reply-To: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
References: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
Date: Sat, 4 Sep 2010 23:24:12 +0200
Message-ID: <AANLkTi=9F1HpUyhGOp0TJdazoshKgxbFkyqWvztb5OeH@mail.gmail.com>
Subject: Re: [PATCH 0/5] input: wacom: Initial support for Bamboo (rev3)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 4, 2010, Henrik Rydberg <rydberg@euromail.se> wrote:
> This the fourth iteration of the Bamboo patches. Hopefully no big
> surprises.  The ordering has changed to allow setting the pressure_max
> which is not parsed in the hid function. Ping's button mapping has
> been implemented, relying on middle-button emulation instead.  The
> lowres quirks now apply to all touch devices in the family.

Thank you Henrik for the patchset. Very much appreciated.

Acked-by: Ping Cheng < pingc@wacom.com>  for the series.

Ping

> Henrik Rydberg (4):
>   input: wacom: Add fuzz parameters to features
>   input: wacom: Collect device quirks into single function (rev2)
>   input: wacom: Add support for the Bamboo Touch trackpad (rev4)
>   input: wacom: Add a quirk for lowres Bamboo devices (rev2)
>
> Ping Cheng (1):
>   input: wacom: Parse the Bamboo device family
>
>  drivers/input/tablet/wacom.h     |    1 +
>  drivers/input/tablet/wacom_sys.c |   57 +++++++++++++-----
>  drivers/input/tablet/wacom_wac.c |  123 +++++++++++++++++++++++++++++++++++++-
>  drivers/input/tablet/wacom_wac.h |   14 ++++
>  4 files changed, 176 insertions(+), 19 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
