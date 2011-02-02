Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1BBM3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:29:44 -0500
Received: from mail.deathmatch.net ([72.66.92.28]:1203 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1BBM3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:29:43 -0500
X-Greylist: delayed 1806 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Feb 2011 07:29:43 EST
Date: Wed, 2 Feb 2011 06:57:43 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Xin Jin <Xin.Jin@atheros.com>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
Message-ID: <20110202115743.GA12386@hash.localnet>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com> <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com> <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com> <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com> <1296633772.3624.2.camel@jlt3.sipsolutions.net> <20110202113052.GA14126@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202113052.GA14126@jm.kir.nu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 01:30:52PM +0200, Jouni Malinen wrote:
> If it is fine to remove the custom wpa_supplicant modifications from
> Android, this is obviously a moot point, but until that happens, the
> easiest approach seems to be to provide a custom driver_*.c based on
> nl80211 to isolate the custom changes to user space and to small part of
> it at that. I don't really want to see new drivers trying to provide
> WEXT support with private ioctls to address need for making it work with
> Android..

I guess my argument is if Atheros is spending resources on porting
drivers to Android, it would be nice to take the time to fix Android's
userspace too.  At any rate, I disagree with the wiki's wording "the
proper approach" as opposed to maybe "the straight-forward approach."

Android already has a custom userspace library that sits between wpa_s
and their Java stack where they could probably stick all of this stuff.
If there is something that is truly missing from the kernel, then by
all means we can add it to nl80211 for everyone's benefit.

-- 
Bob Copeland %% www.bobcopeland.com

