Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab2FTPsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:48:50 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:49530 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753883Ab2FTPst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:48:49 -0400
Date: Wed, 20 Jun 2012 17:48:42 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Thunderbolt, Apple Monitor & MBA, and excess kworker load
Message-ID: <20120620154842.GA5788@air.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

At work, I wish to attach a 27" Apple Display using thunderbolt to my Mac
Book Air 4,2 13". Using OS X, it works fine, but as I prefer using Linux, I
tested out Ubuntu's stock kernel and (among other) 3.5.0-rc3+ as of f40759e.
Hotplug doesn't work (known issue), but also with coldplug the display
reacts _very_ slow, way too slow for real use: The screen updates only every
half second or so. Is this a known bug? Might something go afoul with
kworker -- they need about 75% of the CPU with the large display attached,
and less than 1% _without_ the large display.

Any hints are most welcome, also on where I may dig further to determine the
root causes...

Thanks & best,

	Dominik
