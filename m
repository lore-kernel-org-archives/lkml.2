Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0I2Tkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:40:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34268 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab0I2Tkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=hPmWWmy+YK6U1Wp/sORNqxIhczk+UVua4Mpn5mcSk2Ei1VmWhjxm9FVuU69NSS4Q7o
         9iVwQRbVYlxHnOERnbWiLAqCx0OJf8dUiCMtXrGd7CemUJRg8pW/46nhEPPGnqyAgBMi
         hda8ffBKpFV1pt0uKi7CV8UlakqT9isgPuXR4=
MIME-Version: 1.0
In-Reply-To: <20100924230730.GB6566@tux>
References: <20100924230730.GB6566@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 29 Sep 2010 12:40:23 -0700
X-Google-Sender-Auth: 6g5tBMk39Uu-ALAUORWx8bdk9nw
Message-ID: <AANLkTin3QqukxP8M_L9nWgkrv6bGsnGx1JFNtOY1jXtp@mail.gmail.com>
Subject: Re: RFC: btusb firmware load help
To: Marcel Holtmann <holtmann@linux.intel.com>,
        Ken Steck <Ken.Steck@atheros.com>,
        Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@atheros.com>
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 4:07 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Marcel, I was just poked about this thread:
>
> http://www.spinics.net/lists/linux-bluetooth/msg06087.html
>
> The hack is required because our BT hardware does not accept HCI commands
> when the device is plugged in. If I understood your position you did not
> want to accept the patch because our BT USB devices are violating the
> specification by not acceping HCI commands and yet claiming to be BT
> devices, is that right?
>
> This position seems perfectly reasonable, and if it is violating the
> specification this needs to be fixed in hardware for future devices. But
> what is done is done, and we need to support existing customers with
> current hardware, can you provide some recommendation as to an alternative
> approach to resolve this upstream?

Marcel some attention to this would be greatly appreciated.

> Without a patch like the one suggested Atheros' Bluetooth USB devices are
> essentially not functional at all. I am in hopes we can come to some agreement
> how to deal with a hardware quirk for now while we nag at our hardware team
> to consider changing the way our devices work.

I have gotten clarifications from Ken Steck that this issue is only
present on AR3011 chips used in the SFLASH configuration. AR3012 will
not have this issue.

> Someone from the Atheros BT team: can you send me the same patch to be
> applied into compat-wireless under the linux-next-pending/ directory ?
> That is, send me a patch which will apply onto compat-wireless.
> This way we can actually get our hardware functional to customers while
> we try to look for a better alternative directly upstream. You will
> also need to document this issue on the wiki. I recommend you document
> this here:
>
> http://wireless.kernel.org/en/users/Drivers/ath3k
>
> That is, create a new wiki page there for the driver and the things
> needed for it. Once I get the patch into compat-wireless we can
> refer users/customers to the compat-wireless stable releases with
> the linux-next-pending/ patch you give to me applied.

I saw no takers on this.. so I just created the page myself.

> Someone from the Atheros BT team: does the patch currently handle
> suspend/resume?

Shanmugamkamatchi has noted to me he will be sending me this patch
soon and it also supports suspend/resume properly, however, I would
like to resolve this upstream.

Marcel, please let us know what path you recommend we take for this.

  Luis
