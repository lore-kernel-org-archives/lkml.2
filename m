Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab0FIN6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 09:58:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57946 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0FIN6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 09:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jQAX8p46FcrAaV9lD0H3DW5o6BPanIvaxi5mj4iOfU+u4OvaAQkytb5X5Y9FrKVO3O
         WUNKAB2W2fAEmU4TA9o4Er+CYh31aD8mz7uB7ebPPcUEGypU7IhdXoHrqGh9wjjd5kTv
         5ShnYVKQmU/yJSmlXq5/HyPFTZV+gt7EzgVCM=
MIME-Version: 1.0
In-Reply-To: <4c0f4326.0a41df0a.7bde.ffffeef2@mx.google.com>
References: <4c0f4326.0a41df0a.7bde.ffffeef2@mx.google.com>
Date: Wed, 9 Jun 2010 09:58:37 -0400
X-Google-Sender-Auth: keVnpr2VNPoNhoEFyUYyMYAqers
Message-ID: <AANLkTilrYYHjcMEhhrP7zjcLoo-TNczozxJSNRkDvSZy@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] [ath5k][leds] Ability to disable leds 
	support. If leds support enabled do not force mac802.11 leds layer selection.
From: Bob Copeland <me@bobcopeland.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: ath5k-devel@venema.h4ckr.net, Kalle Valo <kalle.valo@iki.fi>,
       linux-wireless@vger.kernel.org, GeunSik Lim <geunsik.lim@samsung.com>,
       Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Keng-Yu Lin <keng-yu.lin@canonical.com>, netdev@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Shahar Or <shahar@shahar-or.co.il>,
       linux-kernel@vger.kernel.org, Luca Verdesca <magooz@salug.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 3:31 AM, Dmytro Milinevskyy
<milinevskyy@gmail.com> wrote:
> However if the leds support was enabled do not force selection of 802.11 leds layer.

I don't understand this part.  What's the point of enabling software LEDs
if nothing triggers them?

Also, we can probably build hardware LEDs (hw_set_ledstate) in regardless.
It's a pure register write and doesn't require the rest of the LED machinery.

I assume you are doing this to reduce the size of the module.  If so, can
you include size(1) output in the commit message?

-- 
Bob Copeland %% www.bobcopeland.com
