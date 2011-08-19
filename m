Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1HSBZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 21:25:28 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:54094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1HSBZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 21:25:27 -0400
To: Pavel Ivanov <paivanof@gmail.com>
Subject: Re: [PATCH] ath9k: make driver usable standalone
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Aug 2011 03:25:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
        =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <CAG1a4ruH=ctPfAT0-axtckHds=SbjUWRV0Zb=ZTSM+QxV7PZ-w@mail.gmail.com>
 (sfid-20110819_005700_042279_0AD5140A)
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
 <CA+XFjipM1Qup3bcJos_ikwzoaWoa3GdYqK0WBUqEHBNR6V6LfQ@mail.gmail.com>
 <CAG1a4rsyfPrrrf-mzt3HAM6YHHjaHTcd2rbtYiwqLkUCP=j8pQ@mail.gmail.com>
 <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com>
 <CAG1a4rvQTA7UgxLOxu_cC88grjHttyjPD_4kyDhb7Y9FcBBkLQ@mail.gmail.com>
 <1313695217.23920.4.camel@dcbw.foobar.com>
 <CAG1a4rvqdB8y9ARQ=FckArm3UVG7=LFqF25kqYUYL0Uw7QNV8g@mail.gmail.com>
 <1313699724.23920.18.camel@dcbw.foobar.com>
 <CAG1a4ruH=ctPfAT0-axtckHds=SbjUWRV0Zb=ZTSM+QxV7PZ-w@mail.gmail.com>
 (sfid-20110819_005700_042279_0AD5140A)
Message-ID: <e77f44f3b510e72d19e4130c85d3dc11@secure.sipsolutions.net>
User-Agent: Roundcube Webmail/0.5.3
X-sips-origin: local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 18:56:11 -0400, Pavel Ivanov wrote:
>> Or, since I'm a NetworkManager developer, is there something that 
>> you're
>> not sure how to make NM do, or are you just looking to experiment?
>
> I want to make the wireless work when kernel is compiled without
> WIRELESS_EXT. Last time I tried it Ubuntu (I guess I should say
> NetworkManager) wasn't able to discover any wireless networks in our
> area and wasn't able to connect to my default network. Was it 
> supposed
> to do that?

*sigh*

Please quote properly and delete stuff you're not replying to.

Also, have you discovered CONFIG_CFG80211_WEXT yet? It's even "default 
y", so how did you manage to mess it up?

johannes
