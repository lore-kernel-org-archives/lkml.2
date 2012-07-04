Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2GDTD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 15:03:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab2GDTDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 15:03:25 -0400
Date: Wed, 4 Jul 2012 21:03:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>,
        Andrew de los Reyes <adlr@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH 2/2 v4] HID: magicmouse: Implement Multi-touch Protocol
 B (MT-B)
In-Reply-To: <20120704184925.GA443@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1207042102560.17304@pobox.suse.cz>
References: <1341418543-29517-1-git-send-email-miletus@chromium.org> <20120704184925.GA443@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, Henrik Rydberg wrote:

> > The driver for Apple Magic Trackpad/Mouse currently uses
> > Multi-touch Protocol A (MT-A) to report touch events and uses
> > ABS_MT_TRACKING_ID to do finger tracking. The fact of the device
> > being able to track individual finger makes it possible to
> > report touch events using MT-B. This patch converts the driver
> > to use MT-B as it is preferred to MT-A.
> > 
> > V4: Removed BTN_TOUCH evnet.
> > V3: Removed the single touch related logic.
> > V2: Converting entirely to MT-B as Henrik Rydberg suggested.
> > 
> > Signed-off-by: Yufeng Shen <miletus@chromium.org>
[ ... snip ... ]
> 
> Looks good now, both patches get a
> 
> Reviewed-and-tested-by: Henrik Rydberg <rydberg@euromail.se>

Now applied. Thanks!

-- 
Jiri Kosina
SUSE Labs
