Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1BBIDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:03:03 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:45803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab1BBIDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:03:00 -0500
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Xin Jin <Xin.Jin@atheros.com>
In-Reply-To: <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
	 <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
	 <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
	 <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 09:02:52 +0100
Message-ID: <1296633772.3624.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 21:41 -0500, Bob Copeland wrote:
> On Tue, Feb 1, 2011 at 7:50 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> 
> >> I don't think it's good to advocate a custom driver.  They should be able
> >> to use stock wpa_supplicant w/ nl80211 and put the extensions in the
> >> hardware layer.
> >
> > Can you elaborate?
> 
> From the wiki:
> 
> "The proper approach would be to provide a custom driver_nl80211_android.c
> wrapper for the modified wpa_supplicant in Android."
> 
> I just don't think it's strictly necessary to ship a modified wpa_s.
> Why is Android special when bog standard Linux gets by ok with
> driver_nl80211?

Agree, that is a dumb idea. What's that driver going to do? Use custom
nl80211 extensions?! That way lies insanity.

johannes

