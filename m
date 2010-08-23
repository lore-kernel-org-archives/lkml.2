Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0HWXqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:46:45 -0400
Received: from tex.lwn.net ([70.33.254.29]:45071 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab0HWXqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:46:43 -0400
Date: Mon, 23 Aug 2010 17:46:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Eric Anholt <eric@anholt.net>
Subject: Re: [now bisected] i915: 2.6.36-rc2 hoses my Intel display
Message-ID: <20100823174641.4ba58bfe@bike.lwn.net>
In-Reply-To: <8u3s94$gak083@orsmga002.jf.intel.com>
References: <20100823110145.08eb72fd@bike.lwn.net>
	<20100823151708.6b242599@bike.lwn.net>
	<8u3s8d$jcc0rr@orsmga001.jf.intel.com>
	<20100823173225.2bda6f78@bike.lwn.net>
	<8u3s94$gak083@orsmga002.jf.intel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 00:37:52 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> drm.debug=0x4 should print the right information for this bug.

That doesn't seem to give me any output at all.

One thing I noticed, though, is that I occasionally get something like:

Aug 23 17:43:14 bike kernel: [  142.920185] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 51, available = 28.

They seem to come in threes, for whatever that's worth.

Thanks,

jon
