Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1I1L7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 07:59:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53340 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1I1L7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 07:59:39 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: sedat.dilek@gmail.com
Subject: Re: Where to obtain the carl open source firmware?
Date: Wed, 28 Sep 2011 13:59:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc7-wl+; KDE/4.6.5; x86_64; ; )
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
References: <alpine.DEB.2.02.1109280705410.8348@p34.internal.lan> <CA+icZUVVdxVEZ-gYWe3u84YUafUpZwupwBkEL0dsVAdwRB8KDA@mail.gmail.com>
In-Reply-To: <CA+icZUVVdxVEZ-gYWe3u84YUafUpZwupwBkEL0dsVAdwRB8KDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281359.26182.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 28, 2011 01:15:03 PM Sedat Dilek wrote:
> Try <http://linuxwireless.org/en/users/Drivers/carl9170#Firmware>.
> 
> - Sedat -
> 
> On Wed, Sep 28, 2011 at 1:06 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > Hi,
> >
> > Since kernel.org is down and the new kernel (3.x) does not work with the
> > older firmware, where can one obtain the firmware for this open source
> > device so I can run the 3.x kernel?
> >
As Sedat has already pointed out the 1.9.4 firmware binary is hosted
on the wiki-site [Thankfully, Pavel Roskin uploaded it there a while
ago. Who would have tought that it was a good idea... now we know it
sort of is.]

I'll restore the git tree once kernel.org is back in place. Until then
I guess we can stick to email, the source is just around 140 kb packed.

I think the current head is:
d1dbdf395b7ee5330b22008ba7c2cc704e157229 "config: import latest kconfig"

1.9.4 has:
a1d719850538748c7087876a8bce0e3597ca461f "carl9170 firmware: update version to 1.9.4"

Regards,
	Chr
