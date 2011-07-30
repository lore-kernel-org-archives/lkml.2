Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab1G3RHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 13:07:17 -0400
Received: from lucidpixels.com ([72.73.18.11]:34227 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab1G3RHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 13:07:14 -0400
Date: Sat, 30 Jul 2011 13:07:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <4E341DC4.9010107@01019freenet.de>
Message-ID: <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan> <4E318BD0.40202@lwfinger.net> <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan> <4E341DC4.9010107@01019freenet.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Jul 2011, Andreas Hartmann wrote:

> Hi Justin,
>
> if you want to test, if the module works stable, run this script for one
> or two hours. It will stress the driver and the hardware.
>
> If it doesn't crash and if the throughput is stable, you can hope, that
> the driver is ok for daily work.
>
>
> #!/bin/sh
>
> dest="server" # set the servername
>
> while true ; do
> netperf -t TCP_MAERTS -H $dest
> netperf -t TCP_STREAM -H $dest
> netperf -t TCP_SENDFILE -H $dest
> done
>
>
> Start the script on the client. On the server start netserver.
> You get netperf from http://www.netperf.org/netperf/
>
>
> Andreas
>

Hello Andreas,

Thanks for the suggestion; however, it is crashing repeatedly after about 
5-10 minutes, so it is not needed yet.

Here you go, crash 2:
http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p1.jpg
http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p2.jpg

Justin.

