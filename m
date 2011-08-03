Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1HCSmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:42:10 -0400
Received: from lucidpixels.com ([72.73.18.11]:37731 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab1HCSmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:42:06 -0400
Date: Wed, 3 Aug 2011 14:42:04 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <alpine.DEB.2.02.1108031433570.9421@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1108031441140.9421@p34.internal.lan>
References: <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan> <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
 <4E341DC4.9010107@01019freenet.de> <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan> <20110803160050.GA18882@redhat.com> <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan> <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan> <20110803183349.GA5956@redhat.com>
 <alpine.DEB.2.02.1108031433570.9421@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Aug 2011, Justin Piszcz wrote:

>
>
> On Wed, 3 Aug 2011, Stanislaw Gruszka wrote:
>
>> On Wed, Aug 03, 2011 at 01:44:10PM -0400, Justin Piszcz wrote:
>>> Tested that patch:
>>>

Hi,

[ 3552.765072] phy0 -> rt2800_txdone: Error - Data pending
[ 3552.774580] phy0 -> rt2800_txdone: Error - Data pending
[ 3985.215031] ieee80211 phy0: wlan0: No probe response from AP (hidden) after 500ms, disconnecting.
[ 3985.262684] cfg80211: Calling CRDA for country: XX
[ 4011.806042] wlan0: authenticate with (hidden) (try 1)
[ 4011.807577] wlan0: authenticated
[ 4011.824287] wlan0: associate with (hidden) (try 1)
[ 4011.828180] wlan0: RX ReassocResp from (hidden) (capab=0x431 status=0 aid=2)
[ 4011.828189] wlan0: associated
[ 4035.209032] ieee80211 phy0: wlan0: No probe response from AP (hidden) after 500ms, disconnecting.
[ 4035.248719] cfg80211: Calling CRDA to update world regulatory domain
[ 4061.777466] wlan0: authenticate with (hidden) (try 1)
[ 4061.786410] wlan0: authenticated
[ 4061.818460] wlan0: associate with (hidden) (try 1)
[ 4061.822059] wlan0: RX ReassocResp from (hidden) (capab=0x431 status=0 aid=2)
[ 4061.822068] wlan0: associated

Saw this on the rt2800usb driver (w/ your patch), is this normal?

Justin.

