Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579Ab0FKTwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:52:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42106 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759689Ab0FKTwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=QHoyAWZS1IsIgERCaZWWOakbW4E3gNQaP0oL0Wqlxqq9w87lgzIqSuktdmB9WDUAmh
         LcazAIAYZ1S6JA9E9mqWnXa7+oYgIgGUgYD68kovJkSrj1G7GVcZA+KoLSeJHN3225B4
         XPF7JUhBq79pPStReyfsYnOoJ0YFAz+S2WtUc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimUW58T19GOkRk3oCC9huLDQLgLj4W3RjiQ9n53@mail.gmail.com>
References: <4c0f4326.0a41df0a.7bde.ffffeef2@mx.google.com> 
	<AANLkTilrYYHjcMEhhrP7zjcLoo-TNczozxJSNRkDvSZy@mail.gmail.com> 
	<AANLkTimXqdkQxv_Y1JaleTTWNsDIQHQaPn8HR7efOupb@mail.gmail.com> 
	<AANLkTimUW58T19GOkRk3oCC9huLDQLgLj4W3RjiQ9n53@mail.gmail.com>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Fri, 11 Jun 2010 22:52:00 +0300
X-Google-Sender-Auth: Xz__Z1FVQtV-2x9V-aX0j-iLg5k
Message-ID: <AANLkTilECEFWIxXTfykAagSaZUv20Btrz-Fmq3IA8Dap@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] [ath5k][leds] Ability to disable leds 
	support. If leds support enabled do not force mac802.11 leds layer selection.
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, GeunSik Lim <geunsik.lim@samsung.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
       netdev@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Keng-Yu Lin <keng-yu.lin@canonical.com>, Jiri Kosina <jkosina@suse.cz>,
       Shahar Or <shahar@shahar-or.co.il>, linux-kernel@vger.kernel.org,
       Luca Verdesca <magooz@salug.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't know. Thank you for noting that.
However I think it's better to give a chance to disable 802.11 leds.

-- Dima

On Fri, Jun 11, 2010 at 8:07 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, Jun 9, 2010 at 10:43 AM, Dmytro Milinevskyy
> <milinevskyy@gmail.com> wrote:
>> Hi, Bob.
>>
>> For instance I don't use 802.11 leds layer and trigger leds from
>> userspace according to my purposes.
>
> FWIW you can disable mac80211 triggers from userspace as well.
> But, I guess hooking up null triggers will work too.
>
> --
> Bob Copeland %% www.bobcopeland.com
>
