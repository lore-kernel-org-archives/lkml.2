Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1G3L3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 07:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1G3L3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 07:29:06 -0400
Date: Sat, 30 Jul 2011 13:30:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Ivo van Doorn <IvDoorn@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: 3.0: rt2800usb(Kernel PANIC) vs. rt2780sta(GOOD/2.6.38)
Message-ID: <20110730113009.GA2847@redhat.com>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan>
 <4E318BD0.40202@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E318BD0.40202@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 11:18:24AM -0500, Larry Finger wrote:
> On 07/27/2011 06:33 PM, Justin Piszcz wrote:
> Any thoughts on how either the skb or the driver_data member might
> not be setup correctly?

I found a bug that possibly causing this. Justin, please test patch
posted in the next mail.

Stanislaw
