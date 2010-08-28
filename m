Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0H1QGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:06:00 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:52850 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0H1QF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:05:58 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Aug 2010 12:05:58 EDT
In-Reply-To: <1283005748-3293-3-git-send-email-rydberg@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se> <1283005748-3293-3-git-send-email-rydberg@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <2A410207-8AAA-4D5A-846A-B69F007E6800@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 3/3] hid: 3m: Correct touchscreen emulation
Date: Sat, 28 Aug 2010 17:56:52 +0200
To: "Henrik Rydberg" <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 août 10 à 16:29, Henrik Rydberg a écrit :

> The current code sometimes misses to report the last BTN_TOUCH event
> when multiple fingers are lifted simultaneously.  With the
> introduction of MT slots, the tracking id is available to determine
> the oldest active contact.

Hi Henrik,

good job on exploiting the sync quirk!

About the oldest active contact, I'm not so sure though. I don't have  
the device with me but I remember that 3M recycle IDs, giving the  
lowest available ID to any new finger; this means that the lowest ID  
is not always the oldest finger.

Cheers,

St.

