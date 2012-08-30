Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2H3S3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:29:09 -0400
Received: from csmtp2.one.com ([91.198.169.22]:34283 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2H3S3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:29:07 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Thu, 30 Aug 2012 20:34:46 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 20/20] HID: multitouch: Remove the redundant touch
 state
Message-ID: <20120830183446.GA5841@polaris.bitmath.org>
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

> - After a little bit a playing with some surfaces, I can confuse the
> input_mt_assign_slot_by_id function: for the very same contact id, I
> got up to four different slots.... This accumulates the clicks and is
> not very good.... :-(

Reading again, the input-mt match-by-id code does not do anything near
the same thing as the hid-mt match-by-id code, so this is not at all
surprising. Looks like we need to keep that part in hid-mt, and skip
the corresponding input-mt function. Will fix.

Henrik
