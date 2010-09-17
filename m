Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0IQUYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:24:32 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:46678 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0IQUYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:24:31 -0400
Date: Fri, 17 Sep 2010 16:24:29 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Richard Mittendorfer <delist@gmx.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Radeon KMS r100 and STR problems
Message-ID: <20100917202429.GA5091@animx.eu.org>
Mail-Followup-To: Richard Mittendorfer <delist@gmx.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100917202647.aa4b6300.delist@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917202647.aa4b6300.delist@gmx.net>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Mittendorfer wrote:
> Radeon KMS and STR on a X32
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility M6 LY
> 01:00.0 0300: 1002:4c59
> 2.6.36-rc4, Debian Squeeze

> Most of the time: Backlight comes on, screen remains black, box hangs,
> networking in isn't possible (likely due to NM), but  also SysRq
> doesn't do. Hardly ever: Vertical lines, messed up screen, but text (as
> well as mouse movement when switching to Xorg) "is there". One out of
> ~10 tries I saw this when suspending at the console (echo mem>/s/p/state).
> Rebooting blindly was possible then and the logger was able to capture the 
> messages below.

I'd like to add that I've a similar problem with a Mobility M7 with any
kernel with radeon KMS.  One difference is that only the screen is hosed.  I
am still able to use the keyboard and I can connect to it over the network.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
