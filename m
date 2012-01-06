Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab2AFTsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:48:19 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:43264 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2AFTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:48:18 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au5VAONOB09V5qrvPGdsb2JhbABDiVaiahkBAQEBNzKBcgEBBAE6HCMQCANGFCUKGogNArY8E4sbYwSNModUhV+MWA
X-IronPort-AV: E=Sophos;i="4.71,469,1320620400"; 
   d="scan'208";a="247797487"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 6 Jan 2012 20:48:15 +0100
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: evdev - Add EVIOC mechanism to extract the MT
 slot state
Message-ID: <20120106194815.GA3116@polaris.bitmath.org>
References: <1325863019-2242-1-git-send-email-rydberg@euromail.se>
 <CAN+gG=FUEH851Um4Lco0avqdE2Eup3Jo79Ti4T7XhxT=PO6WeQ@mail.gmail.com>
 <20120106181845.GA22653@core.coreip.homeip.net>
 <20120106185544.GB2795@polaris.bitmath.org>
 <20120106191835.GA2998@polaris.bitmath.org>
 <4F074CAE.7010205@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F074CAE.7010205@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok, maybe not to so easy after all, which probably answers my own
> > question. Looks like a EVIOCGMTSLOT, taking both slot and event code
> > as argument, would be the cleaner route to take. Another ioctl, how do we
> > feel about that?
> 
> What's the problem with userspace locking?

The idea was to get by without it.

Regarding ioctls, it does not seem realizable due to ioctl number
exhaustion. A sysfs interface for all EV_ABS and per-slot MT values
could be a more future-proof alternative.

Henrik
