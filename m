Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab1BBAuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:50:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33720 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1BBAum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VXqBFqepGkWLM7OfVh7fR1fSJmaj7TX/4MoYNXTpfeD9ji9nmtLWe0T4XfYZnQ80RY
         KerlRvgoaVjlQOO0TuhCO/YMsXta/Zst+ymjgQNNnBzv2Xm+hSgJRPy+lHTX/lTygzY9
         idw9SbPcxupzcaHZJpMDDIa1kvO/9Xb7NkjQI=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com> <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Feb 2011 16:50:21 -0800
Message-ID: <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Xin Jin <Xin.Jin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 4:45 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Feb 1, 2011 at 6:29 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> We get poked every now and then for Android support for mac80211 or
>> cfg80211 drivers. Since the questions is quite common I figured It'd
>> be good to document what needs to get done for this. Android folks,
>> you listening?
>>
>> http://wireless.kernel.org/en/developers/Documentation/Android
>>
>> If you already have worked on this or are going to please feel free to
>> update the wiki so no one else re-invents the wheel.
>
> I don't think it's good to advocate a custom driver.  They should be able
> to use stock wpa_supplicant w/ nl80211 and put the extensions in the
> hardware layer.

Can you elaborate?

 Luis
