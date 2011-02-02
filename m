Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1BBAtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:49:06 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54718 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1BBApN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FkYDWk8OHmPddA2yBt0BZCiL1u/n4DyRdzZSob296DvIqBrK5CxcD2yS0vgjlJD9PY
         InSfecgwkq4lGo6lw/te1LtGBbHSjPWOyBH4prJQHSvaf9HAVoM8u4vRCHspHh3j5NQB
         u0zJV1O4T+w6nDAVTUP0300coebND4vXjNW0Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
Date: Tue, 1 Feb 2011 19:45:12 -0500
X-Google-Sender-Auth: 1vvOabIKK8kuvqu9JMpdgk4lObg
Message-ID: <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Xin Jin <Xin.Jin@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 6:29 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> We get poked every now and then for Android support for mac80211 or
> cfg80211 drivers. Since the questions is quite common I figured It'd
> be good to document what needs to get done for this. Android folks,
> you listening?
>
> http://wireless.kernel.org/en/developers/Documentation/Android
>
> If you already have worked on this or are going to please feel free to
> update the wiki so no one else re-invents the wheel.

I don't think it's good to advocate a custom driver.  They should be able
to use stock wpa_supplicant w/ nl80211 and put the extensions in the
hardware layer.

-- 
Bob Copeland %% www.bobcopeland.com
