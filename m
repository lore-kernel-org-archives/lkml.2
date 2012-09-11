Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab2IKVDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:03:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65427 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2IKVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:03:15 -0400
Date: Tue, 11 Sep 2012 23:04:34 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v4] can: rename LED trigger name on netdev renames
Message-ID: <20120911210434.GA3895@gmail.com>
References: <20120907071934.GB37685@macbook.local>
 <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910142827.GB11000@vandijck-laurijssen.be>
 <504E30AE.50201@hartkopp.net>
 <20120910184049.GD2006@gmail.com>
 <20120910200648.GB546@vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910200648.GB546@vandijck-laurijssen.be>
X-Operating-System: Linux balto-eee 3.6.0-rc3-balto-eee-00469-g5b836b0
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kurt,

On Mon, Sep 10, 2012 at 10:06:48PM +0200, Kurt Van Dijck wrote:
> can: rename LED trigger name on netdev renames
> 
> The LED trigger name for CAN devices is based on the initial
> CAN device name, but does never change. The LED trigger name
> is not guaranteed to be unique in case of hotplugging CAN devices.
> 
> This patch tries to address this problem by modifying the
> LED trigger name according to the CAN device name when
> the latter changes.
> 
> v1 - Kurt Van Dijck
> v2 - Fabio Baltieri
> - remove rename blocking if trigger is bound
> - use led-subsystem function for the actual rename (still WiP)
> - call init/exit functions from dev.c
> v3 - Kurt Van Dijck
> - safe operation for non-candev based devices (vcan, slcan)
> 	based on earlier patch
> v4 - Kurt Van Dijck
> - trivial patch mistakes fixed

Well done, I'm testing the last patches (my can-leds-devel branch on
github) and seems to work good (tested rename, disconnect-reconnect,
vcan rename, rename from udev rule).

Now I think we just have to wait for Bryan for the LED rename patch.

Fabio

-- 
Fabio Baltieri
