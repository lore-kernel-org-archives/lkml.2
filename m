Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2KMSsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:48:46 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:44760 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2KMSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:48:44 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjmxANuUolBV5h1yPGdsb2JhbABEhTEjhQC4JgIBfhkBAQEBHxkNJ4IeAQEEATocIwULCANGFCUKGogXCqorkDIUjQ+BfoJ8YQOVe4V7jTk
X-IronPort-AV: E=Sophos;i="4.80,768,1344204000"; 
   d="scan'208";a="151440620"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 19:55:05 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/13] HID: hid-multitouch: support for hovering
 devices
Message-ID: <20121113185505.GA3641@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-12-git-send-email-benjamin.tissoires@gmail.com>
 <20121113164239.GA712@polaris.bitmath.org>
 <CAN+gG=EbAdfOG_vwt2uamV+JcAKLFqM=zTo9oRQ9RLayrpdsoA@mail.gmail.com>
 <20121113180453.GA3622@polaris.bitmath.org>
 <CAN+gG=HyDrr7mWsYGFue_xuzX0xm45n1EDpsDgU1RKJ8SkuP9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=HyDrr7mWsYGFue_xuzX0xm45n1EDpsDgU1RKJ8SkuP9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just intend to force the update of the distance value at the
> beginning of the touch.
> This is just to send a coherent state when the finger goes in range,
> and to make sure that user-space application do not rely on the
> undefined value (0) whereas the kernel thought it was set to 1.

Right, so we use EVIOCGMTSLOTS. This "problem" occurs with
ABS_MT_ORIENTATION as well.

Thanks,
Henrik
