Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1BBLeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:34:01 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:34438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab1BBLd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:33:59 -0500
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Bob Copeland <me@bobcopeland.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Xin Jin <Xin.Jin@atheros.com>
In-Reply-To: <20110202113052.GA14126@jm.kir.nu>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
	 <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
	 <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
	 <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
	 <1296633772.3624.2.camel@jlt3.sipsolutions.net>
	 <20110202113052.GA14126@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 12:33:54 +0100
Message-ID: <1296646434.5671.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 13:30 +0200, Jouni Malinen wrote:

> > Agree, that is a dumb idea. What's that driver going to do? Use custom
> > nl80211 extensions?! That way lies insanity.
> 
> The only reason for that is to be able to support the wpa_supplicant
> modifications used in Android that are not acceptable for upstream
> hostap.git (mainly, driver_cmd). This would not add any custom nl80211
> extensions; the needed functionality should be added properly to
> upstream nl80211.

What's the driver_cmd things they use? If we they add support for
whatever it is to nl80211, why can those not be normal supplicant
interfaces?

> If it is fine to remove the custom wpa_supplicant modifications from
> Android, this is obviously a moot point, but until that happens, the
> easiest approach seems to be to provide a custom driver_*.c based on
> nl80211 to isolate the custom changes to user space and to small part of
> it at that. I don't really want to see new drivers trying to provide
> WEXT support with private ioctls to address need for making it work with
> Android..

Indeed -- no way. Seems Android needs to learn upstream.

johannes

