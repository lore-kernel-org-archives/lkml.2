Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1BBCl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 21:41:28 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44821 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1BBCl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 21:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wNr4FiYLuwIPl6b/6pvr5q0udKvZC8QThwoc1v4eZu60RRtWGGCit/oba7EixOzMBH
         GmfLaXqyHoHiAt2JX3MRT3upHl80LcOIMzHhwj/bI5qWHk5jmBr+81figbCpFQeed82y
         ooRMJLiHh5ZzaaZ216A3XxXLAXKTu27bsLhw0=
MIME-Version: 1.0
In-Reply-To: <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
	<AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
	<AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
Date: Tue, 1 Feb 2011 21:41:24 -0500
X-Google-Sender-Auth: FYUK2dVNAVqln2ARDVG_1e3oZIU
Message-ID: <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 7:50 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

>> I don't think it's good to advocate a custom driver.  They should be able
>> to use stock wpa_supplicant w/ nl80211 and put the extensions in the
>> hardware layer.
>
> Can you elaborate?

>From the wiki:

"The proper approach would be to provide a custom driver_nl80211_android.c
wrapper for the modified wpa_supplicant in Android."

I just don't think it's strictly necessary to ship a modified wpa_s.
Why is Android special when bog standard Linux gets by ok with
driver_nl80211?

-- 
Bob Copeland %% www.bobcopeland.com
