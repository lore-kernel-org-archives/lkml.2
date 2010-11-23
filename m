Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0KWXCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:02:31 -0500
Received: from eazy.amigager.de ([213.239.192.238]:32781 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0KWXCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:02:30 -0500
Date: Wed, 24 Nov 2010 00:02:51 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915/sdvo: Always fallback to querying the shared
 DDC line
Message-ID: <20101123230251.GA5036@mac.home>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	linux-kernel@vger.kernel.org
References: <20101123214704.GA26884@mac.home>
 <1290552152-16026-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290552152-16026-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 22:42:32 +0000, Chris Wilson wrote:
> On a few devices, like the Mac Mini, the CRT DDC pins are shared between
> the analog connector and the digital connector. In this scenario, use
> the EDID to determine if a digital panel is connected to the digital
> connector.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
> 
> Looking closer I can't see any rationale for checking whether or not the
> analog device is attached since we check whether the display is digital
> before accepting the EDID.

Hi,

works fine with 2.6.37-rc3.

Thanks and regards,
Tino
