Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1CQUSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:18:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42025 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755456Ab1CQUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:18:37 -0400
Date: Thu, 17 Mar 2011 20:18:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        andy.green@linaro.org, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317201835.GM31411@opensource.wolfsonmicro.com>
References: <20110311160308.GQ1760@opensource.wolfsonmicro.com>
 <20110311161421.GA7843@kroah.com>
 <20110311162759.GS1760@opensource.wolfsonmicro.com>
 <20110311163522.GA9291@kroah.com>
 <20110311164850.GT1760@opensource.wolfsonmicro.com>
 <20110311165642.GA9996@kroah.com>
 <20110311170807.GV1760@opensource.wolfsonmicro.com>
 <20110311172345.GA10876@kroah.com>
 <alpine.LFD.2.00.1103162207130.26889@xanadu.home>
 <20110317201320.GB4035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317201320.GB4035@kroah.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 01:13:20PM -0700, Greg KH wrote:
> On Wed, Mar 16, 2011 at 10:14:01PM -0400, Nicolas Pitre wrote:

> > PandaBoards are becoming quite popular.

> I have one right here.

> But can't this device be detected by the usb device id and the quirk
> added that way?  Like all other "odd" USB devices are currently handled?

It's going to be an off the shelf USB ethernet controller.  I'd be
astonished if the board-configurable device IDs weren't set from the
same SEPROM that the MAC address is so it'd just show up as a generic
chip of whatever kind.
