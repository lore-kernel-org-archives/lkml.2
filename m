Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1HCSck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:32:40 -0400
Received: from lucidpixels.com ([72.73.18.11]:40369 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab1HCScd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:32:33 -0400
Date: Wed, 3 Aug 2011 14:32:32 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1108031351300.9421@p34.internal.lan>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan> <4E318BD0.40202@lwfinger.net> <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan> <4E341DC4.9010107@01019freenet.de> <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan> <20110803160050.GA18882@redhat.com> <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan>
 <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Aug 2011, Justin Piszcz wrote:

>
>
> On Wed, 3 Aug 2011, Justin Piszcz wrote:
>

For the rt2800usb driver:

It has not crashed in 1hr with the 3.0 kernel:

[ 1027.102856] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.110496] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.114880] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.117616] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.120272] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.143371] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.147252] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.150505] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.153541] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.156118] phy0 -> rt2800_txdone: Error - Data pending
[ 1027.167250] phy0 -> rt2800_txdone: Error - Data pending
[ 1089.588039] phy0 -> rt2800_txdone: Error - Data pending
[ 1089.623248] phy0 -> rt2800_txdone: Error - Data pending
[ 1089.626370] phy0 -> rt2800_txdone: Error - Data pending

Will reboot again and see if it auto-loads (or if a manual modprobe is 
necessary)..

Justin.
