Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2CLSHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:07:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38502 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2CLSHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:07:44 -0400
Date: Mon, 12 Mar 2012 18:07:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: simon@mungewell.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
Message-ID: <20120312180738.GD14020@sirena.org.uk>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>
 <alpine.LNX.2.00.1203121645050.18356@pobox.suse.cz>
 <be2be8d04b58ce75fcba9798fcb4e4fa.squirrel@mungewell.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be2be8d04b58ce75fcba9798fcb4e4fa.squirrel@mungewell.org>
X-Cookie: Yow!  Are we laid back yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 02:04:14PM -0400, simon@mungewell.org wrote:

> At the moment you'd just drive the LEDs simply, ie:
> $ echo 31 > /sys/bus/hid/devices/.../leds

Shouldn't this be using the LED subsystem the kernel already has?
