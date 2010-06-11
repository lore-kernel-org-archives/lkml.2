Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab0FKU0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:26:46 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59280 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab0FKU0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=rhlFUWng07yJSzzZ540c+GQqX4x2fpjPfeb3Ty3Tf3piuPOuFYGUvtCsjcLHUm32mn
         Aajvz9mUA33bVsVNjl0q6QONWIVvdXxwueUTe5ceclkb6nYAF+i6+vTqAflFRkcjq2uM
         WkgSR5TtU5tlpz1oaKs6x03v2tVzaUSwhCbJE=
MIME-Version: 1.0
In-Reply-To: <1276286993.3918.0.camel@jlt3.sipsolutions.net>
References: <4c0f4326.0a41df0a.7bde.ffffeef2@mx.google.com> 
	<AANLkTilrYYHjcMEhhrP7zjcLoo-TNczozxJSNRkDvSZy@mail.gmail.com> 
	<AANLkTimXqdkQxv_Y1JaleTTWNsDIQHQaPn8HR7efOupb@mail.gmail.com> 
	<1276286993.3918.0.camel@jlt3.sipsolutions.net>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Fri, 11 Jun 2010 23:26:23 +0300
X-Google-Sender-Auth: iqtZiqM4ZpT2c4jBd0rnfvYryHQ
Message-ID: <AANLkTim90VBfWjp2YPYeYN6ImjIyZzcJ_XnpT5cdgCt4@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] [ath5k][leds] Ability to disable leds 
	support. If leds support enabled do not force mac802.11 leds layer selection.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@venema.h4ckr.net,
       Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
       GeunSik Lim <geunsik.lim@samsung.com>, Jiri Slaby <jirislaby@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Keng-Yu Lin <keng-yu.lin@canonical.com>, netdev@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Shahar Or <shahar@shahar-or.co.il>,
       linux-kernel@vger.kernel.org, Luca Verdesca <magooz@salug.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic LED class is not disabled so it's possible to control leds in sysfs.

-- Dima

On Fri, Jun 11, 2010 at 11:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-06-09 at 17:43 +0300, Dmytro Milinevskyy wrote:
>> Hi, Bob.
>>
>> For instance I don't use 802.11 leds layer and trigger leds from
>> userspace according to my purposes.
>
> Without the LED stuff in sysfs, how do you do that?
>
> johannes
>
>
