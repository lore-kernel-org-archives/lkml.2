Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2H2P51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:57:27 -0400
Received: from csmtp2.one.com ([91.198.169.22]:55062 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab2H2P50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:57:26 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Wed, 29 Aug 2012 18:02:57 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 20/20] HID: multitouch: Remove the redundant touch
 state
Message-ID: <20120829160257.GA434@polaris.bitmath.org>
References: <1345985858-445-1-git-send-email-rydberg@euromail.se>
 <1345985858-445-21-git-send-email-rydberg@euromail.se>
 <CAN+gG=H4K2C0fovqv2u2WxcfhxTAH+_et02mFxKCYUaQdMYJMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=H4K2C0fovqv2u2WxcfhxTAH+_et02mFxKCYUaQdMYJMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - I don't know if it is my configuration or not, but I'm receiving at
> each frame (between two EV_SYN) all ABS_MT_SLOT events, even when
> there are not used.

Your configuration is fine, I screwed up. Will fix.

> - After a little bit a playing with some surfaces, I can confuse the
> input_mt_assign_slot_by_id function: for the very same contact id, I
> got up to four different slots.... This accumulates the clicks and is
> not very good.... :-(

Sounds odd, what device would that be?

Henrik
