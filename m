Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1AMNXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:23:10 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:6154 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab1AMNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:23:08 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 08:23:08 EST
X-IronPort-AV: E=Sophos;i="4.60,317,1291590000"; 
   d="scan'208";a="95194741"
Date: Thu, 13 Jan 2011 14:13:23 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] leds: add keyboard num/caps lock trigger
Message-ID: <20110113131323.GJ5995@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Arnaud Patard <arnaud.patard@rtp-net.org>, rpurdie@rpsys.net,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20110113125921.818344418@rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110113125921.818344418@rtp-net.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


Arnaud Patard, le Thu 13 Jan 2011 13:59:13 +0100, a écrit :
> Implement a led trigger which enable/disable a led according
> to keyboard leds events.

This is already being implemented in a more generic and useful way,
also permitting to use the keyboard leds for other triggers, see the
leds-route-kbd-leds-through-the-generic-leds-layer.patch in the mm tree,
and the “route kbd LEDs through the generic LEDs layer” thread here.

Samuel
