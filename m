Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1HEQNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:13:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47697 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1HEQNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1108040400570.4278@p34.internal.lan>
References: <20110730113009.GA2847@redhat.com>
	<20110730113255.GB2847@redhat.com>
	<alpine.DEB.2.02.1107300736010.4925@p34.internal.lan>
	<alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
	<alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
	<4E341DC4.9010107@01019freenet.de>
	<alpine.DEB.2.02.1107301305590.4925@p34.internal.lan>
	<20110803160050.GA18882@redhat.com>
	<alpine.DEB.2.02.1108031328030.9421@p34.internal.lan>
	<alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
	<20110803183349.GA5956@redhat.com>
	<alpine.DEB.2.02.1108040400570.4278@p34.internal.lan>
Date: Fri, 5 Aug 2011 09:13:41 -0700
X-Google-Sender-Auth: VUIMO_I6OXZ07gMcsVDGxJ-xIFw
Message-ID: <CAJu5p2cP7T3_kcCOM9+h3Xf_V4S0qg0tUztD_7JzkGz0ek2STQ@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800: fix zeroing skb structure
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
        Alan Piszcz <ap@solarrain.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 1:03 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Aug  3 22:47:12 atom kernel: [26120.279774] wlan0: deauthenticated from
> hidden (Reason: 2)

Thinking about it, I'm also seeing similar "deauthenticated" message
in kernel logs on my system infrequently (with Linksys WUSB600N, hw
rev 1, rt2870 chip).  About few times a day, if I leave my system on
24/7.  In my case, the reason code listed is "3".  Most times it
re-authenticates with AP automatically, though sometimes it gives up
and I need to tell it manually to try to re-connect to AP (using
NetworkManager).

Haven't gave it much thought before, as I usually have this system
powered on for only few hours at a time, not long enough for problem
to occur.  Unless I forget to power it off and it stays on overnight
(and then by the morning, it's bound to have at least few
"deauthenticated" messages logged).
