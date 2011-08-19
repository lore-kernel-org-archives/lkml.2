Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab1HSE2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 00:28:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35896 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1HSE2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 00:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAG1a4ruH=ctPfAT0-axtckHds=SbjUWRV0Zb=ZTSM+QxV7PZ-w@mail.gmail.com>
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
 <CA+XFjipM1Qup3bcJos_ikwzoaWoa3GdYqK0WBUqEHBNR6V6LfQ@mail.gmail.com>
 <CAG1a4rsyfPrrrf-mzt3HAM6YHHjaHTcd2rbtYiwqLkUCP=j8pQ@mail.gmail.com>
 <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com>
 <CAG1a4rvQTA7UgxLOxu_cC88grjHttyjPD_4kyDhb7Y9FcBBkLQ@mail.gmail.com>
 <1313695217.23920.4.camel@dcbw.foobar.com> <CAG1a4rvqdB8y9ARQ=FckArm3UVG7=LFqF25kqYUYL0Uw7QNV8g@mail.gmail.com>
 <1313699724.23920.18.camel@dcbw.foobar.com> <CAG1a4ruH=ctPfAT0-axtckHds=SbjUWRV0Zb=ZTSM+QxV7PZ-w@mail.gmail.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Fri, 19 Aug 2011 00:27:46 -0400
Message-ID: <CAG1a4rttmkFW2UrmGvAvop3==ZqjATDj09DLtdCKedGdy-cRgg@mail.gmail.com>
Subject: Re: [PATCH] ath9k: make driver usable standalone
To: Dan Williams <dcbw@redhat.com>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 6:56 PM, Pavel Ivanov <paivanof@gmail.com> wrote:
>> Or, since I'm a NetworkManager developer, is there something that you're
>> not sure how to make NM do, or are you just looking to experiment?
>
> I want to make the wireless work when kernel is compiled without
> WIRELESS_EXT. Last time I tried it Ubuntu (I guess I should say
> NetworkManager) wasn't able to discover any wireless networks in our
> area and wasn't able to connect to my default network. Was it supposed
> to do that?

Well, I guess I should say sorry. After all this discussion I've tried
to compile and boot kernel without WIRELESS_EXT once more. And now it
worked.
Last time I tried it was 3.0. Driver from vanilla sources didn't work,
so I compiled compat-wireless-3.0-2 and it did warn me during
compilation, something like "WIRELESS_EXT is not set, something won't
work". Then after boot syslog had somewhat the same message and
wireless didn't work. That's why I started this thread. Now with
3.1-rc2 everything works as is, no warnings in syslog and
NetworkManager connects to my network without any problems. I don't
know what has changed but I feel very sorry for all this mess.


Pavel
