Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1CXJGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:06:37 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:32947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1CXJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:06:36 -0400
Subject: Re: Update on Android PM enhancements - CONFIG_HAS_EARLYSUSPEND
 and friends
From: Johannes Berg <johannes@sipsolutions.net>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, devel@linuxdriverproject.org,
        Naveen Singh <nsingh@atheros.com>, Kalle Valo <kvalo@adurom.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Vipin Mehta <vmehta@atheros.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1300957495.3807.7.camel@jlt3.sipsolutions.net>
References: <AANLkTik69v+gdPzwdMSyVnvHMKbWquvfCFvHLmLu-bBB@mail.gmail.com>
	 <AANLkTikurVF_-u8gTqM3ireKia28zMrkXRyrvdNTob7e@mail.gmail.com>
	 <1300957495.3807.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 10:06:30 +0100
Message-ID: <1300957590.3807.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 10:04 +0100, Johannes Berg wrote:
> On Wed, 2011-03-23 at 17:47 -0700, Arve Hjønnevåg wrote:
> 
> > There is no planned replacement for early suspend, and it will
> > probably be dropped form the android kernel at some point. The wifi
> > driver use it to enter a lower operating state when the screen is off.
> > If you driver does have any other way to put the driver in this state
> > you need to add an interface that lets user-space select that state
> > directly.
> 
> The interface is called "ip link set wlan0 down".

Or, in fact, just powersaving mode. But I don't think for a wifi driver
there's any need for special driver specific states.

johannes

