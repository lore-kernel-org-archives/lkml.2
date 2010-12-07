Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0LGKeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:34:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52316 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab0LGKeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LzZNKgOm4t+xqq7C3fPvIh5Xwt1dsA/Jo7Koj7gbVeqOzOK3AfPAOuFmEX5bJXBYGl
         aaF0LeLeRq9K6W8voDvg++mMUwUh+z5Z8+OkxIVw0CiJ+g1bfEWE3aNupk29ET0aSLWI
         0lKKjN0+dl2ydxVkbYB3stDiGb+JXsNR4WWB4=
MIME-Version: 1.0
In-Reply-To: <175BA60FBA444BE6B858D42E7B602A40@hacdom.okisemi.com>
References: <175BA60FBA444BE6B858D42E7B602A40@hacdom.okisemi.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 7 Dec 2010 11:34:00 +0100
Message-ID: <AANLkTin-gpuz1jwtL+tpvUaK6XZBfRXYv2ciz_W_sMU9@mail.gmail.com>
Subject: Re: [PATCH net-next-2.6 8/17 v2] can: EG20T PCH: Change Copyright and
 module description
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/7 Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>:
>> In case single destination address is OK, but in case multiple address is
>> set,
>> I can see the following error.
>> Relay access denied
>
> The above was not true.
> It seems in case destination mail domain is external, (except
> "@okisemi.com"),
> this error is occurred.
> In fact, in case multiple address with internal domain,
> it is success to send patch.
>
> Our smtp server may have restriction of something.
>
> It seems I must use mailer "thunderbird" again.

For me, Evolution worked fine (no line wrapping, etc.).

>
> Thanks,
>
> /_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
> Tomoya Morinaga
> OKI SEMICONDUCTOR CO., LTD.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
