Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0FIOoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 10:44:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44053 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab0FIOoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=L4FXggea4B8rWPCj9jD0mviqPIUq7lb7k+imiIeYA3Nj6S7p1jwMamtEY9hFA5/ZPK
         ftxov+ZnRjwGut9zv8KI9+BI90r25J+CngZa66EqvHkVQ4pNWjNWGlEt3fcSezBj3jiw
         g9eKG8/AogfMEjUuI6UZeH65WGmFeO+0eiYjI=
MIME-Version: 1.0
In-Reply-To: <AANLkTilrYYHjcMEhhrP7zjcLoo-TNczozxJSNRkDvSZy@mail.gmail.com>
References: <4c0f4326.0a41df0a.7bde.ffffeef2@mx.google.com> 
	<AANLkTilrYYHjcMEhhrP7zjcLoo-TNczozxJSNRkDvSZy@mail.gmail.com>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Wed, 9 Jun 2010 17:43:48 +0300
X-Google-Sender-Auth: IGMLI5Dh01wQqjeDG_w90YXB6Q4
Message-ID: <AANLkTimXqdkQxv_Y1JaleTTWNsDIQHQaPn8HR7efOupb@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] [ath5k][leds] Ability to disable leds 
	support. If leds support enabled do not force mac802.11 leds layer selection.
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@venema.h4ckr.net, Kalle Valo <kalle.valo@iki.fi>,
       linux-wireless@vger.kernel.org, GeunSik Lim <geunsik.lim@samsung.com>,
       Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Keng-Yu Lin <keng-yu.lin@canonical.com>, netdev@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Shahar Or <shahar@shahar-or.co.il>,
       linux-kernel@vger.kernel.org, Luca Verdesca <magooz@salug.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bob.

For instance I don't use 802.11 leds layer and trigger leds from
userspace according to my purposes.

-- Dima

On Wed, Jun 9, 2010 at 4:58 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, Jun 9, 2010 at 3:31 AM, Dmytro Milinevskyy
> <milinevskyy@gmail.com> wrote:
>> However if the leds support was enabled do not force selection of 802.11 leds layer.
>
> I don't understand this part.  What's the point of enabling software LEDs
> if nothing triggers them?
>
> Also, we can probably build hardware LEDs (hw_set_ledstate) in regardless.
> It's a pure register write and doesn't require the rest of the LED machinery.
>
> I assume you are doing this to reduce the size of the module.  If so, can
> you include size(1) output in the commit message?
>
> --
> Bob Copeland %% www.bobcopeland.com
>
