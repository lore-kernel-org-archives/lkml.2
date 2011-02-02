Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1BBQhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:37:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34968 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab1BBQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=LHbO82oCzVK5CUEaTQImqftDUrz06J7HorLFOylQ7hG5fnEbczkULFSU9CALRAOZlt
         xgWKfA6d4Jna1Zrr5ZxSuOnMCh2Kdj8aRVn2V6T2eA3cTLE2vVRQoQO7spF80ka6NDzZ
         9l8MVrhS5oc1j2DVQB0/mpmtsTCMTeZVcXtQU=
MIME-Version: 1.0
In-Reply-To: <20110202133839.GA14904@jm.kir.nu>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
 <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
 <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
 <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
 <1296633772.3624.2.camel@jlt3.sipsolutions.net> <20110202113052.GA14126@jm.kir.nu>
 <1296646434.5671.1.camel@jlt3.sipsolutions.net> <20110202133839.GA14904@jm.kir.nu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Feb 2011 08:37:11 -0800
Message-ID: <AANLkTimimuho23cY7LR+HN0+VXf4Xo+i4S8EHHz3ORhK@mail.gmail.com>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Bob Copeland <me@bobcopeland.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Xin Jin <Xin.Jin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 5:38 AM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Feb 02, 2011 at 12:33:54PM +0100, Johannes Berg wrote:
>> What's the driver_cmd things they use? If we they add support for
>> whatever it is to nl80211, why can those not be normal supplicant
>> interfaces?
>
> I have not reviewed what exactly gets used and how, so this is only
> based on what the modification for wpa_supplicant are exposing.
>
> There seems to be some kind of mechanism for stopping/starting/reloading
> the driver which I do not fully understand. It includes some kind of
> driver hang detection and maybe recovery from that etc..
>
> Then there is a very generic mechanism of passing any command from user
> space (i.e., command string to a SIOCSIWPRIV) and that goes
> transparently through wpa_supplicant.. The response comes back as a
> string. In other words, you could implement pretty much anything in a
> driver specific way with that.. At least following commands are used or
> have used with that: RSSI, LINKSPEED, MACADDR, GETPOWER, GETBAND.
>
> Since it is difficult to tell just from wpa_supplicant changes what
> exactly is done with these interfaces, the answer to the question of
> why these could not be normal supplicant interfaces is not immediately
> clear to me. I would assume that some of this functionality could
> certainly be added once identified clearly what is needed. Some may
> already be available (like MACADDR; assuming it is used to fetch local
> MAC address).

Sounds like Android kernel guys need to get their shit together. Why
is this so hard?

  Luis
