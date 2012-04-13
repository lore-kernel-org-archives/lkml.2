Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2DMQTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:19:17 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:35141 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2DMQTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:19:16 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Amp3ANRQiE9V5qnhPGdsb2JhbAA7AQmKKKtNBIEFGQEBAQE3NIIJAQEFOhwjEAgDDgouFCUKGhGIFLlOE4sbAS2FGGMElWuGAo0ePA
X-IronPort-AV: E=Sophos;i="4.75,418,1330902000"; 
   d="scan'208";a="311158885"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 13 Apr 2012 18:21:53 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        =?utf-8?B?5p6X77+94pSv77+9?= <tom_lin@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org
Subject: Re: [PATCH v3] Input: Elan HID-I2C device driver
Message-ID: <20120413162153.GA8602@polaris.bitmath.org>
References: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw>
 <20120411071212.GB6894@core.coreip.homeip.net>
 <4F85583F.6050008@emc.com.tw>
 <20120411162519.GA27562@core.coreip.homeip.net>
 <4F8631C8.1090705@emc.com.tw>
 <alpine.LNX.2.00.1204131442520.16373@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204131442520.16373@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 02:43:14PM +0200, Jiri Kosina wrote:
> On Thu, 12 Apr 2012, Benjamin Tissoires wrote:
> 
> > I read Microsoft's things about HID over I2C few days ago. And from
> > what I understood, the report descriptors and the enumeration of the
> > devices are stored in the ACPI table and not in the device itself. Can
> > you confirm this?
> > 
> > I was thinking about making hid-multitouch independent from the usb
> > stack and was thinking about doing the i2c-hid bridge. However, I did
> > not start writing a line yet ;-)
> 
> I guess you were planning to write that as a HID transport (ll) driver, 
> right?

Sounds great. The recent investigations into the properties of the hid
device identity for multitouch suggests that the ll driver could be
seen as the owner of the hid device itself, and should take on the
responsibility of both report fixups and determining the device
identify (read modalias). Using generic code (hid-owner?) of course. I
am experimenting with a couple of patches for it. Would you all agree
with this assessment?

Henrik
