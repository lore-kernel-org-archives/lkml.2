Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0GMMug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 08:50:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47619 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0GMMue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 08:50:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C3C6106.3000909@s5r6.in-berlin.de>
Date: Tue, 13 Jul 2010 14:50:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>
CC: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: rt2x00: slow wifi with correct basic rate bitmap (was Re: stable?
 quality assurance?)
References: <201007110918.42120.Martin@lichtvoll.de>	<AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com>	<201007111651.42963.Martin@lichtvoll.de> <20100713131112.26a3da54@varda>
In-Reply-To: <20100713131112.26a3da54@varda>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alejandro Riveira Fernández wrote:
>  I for one stopped booting into -rc kernels.
>  The fact that still have to patch my kernels with a *one* liner
>  since 2.6.29 kernel [1] does not give me confidence on the "test
>  report/bisect and it will be fixed" promise some have made in this
>  threath
>  
>  [1] https://bugzilla.kernel.org/show_bug.cgi?id=13362

There were promises made in this thread?  Then I must have read a
different mailinglist or so.

I do not know why your WLAN regression has not been fixed yet, but at
least it seems rather plausible why commit
7e0986c17f695952ce5d61ed793ce048ba90a661 is not going to be reverted (if
such a revert is the one-liner that you are referring to).

Why is one reporter's rt2500 OK now though but not yours?  Are there
different card revisions or firmwares out there that require quirk handling?
-- 
Stefan Richter
-=====-==-=- -=== -==-=
http://arcgraph.de/sr/
