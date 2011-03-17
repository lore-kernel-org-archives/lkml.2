Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1CQUNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:13:41 -0400
Received: from kroah.org ([198.145.64.141]:52613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab1CQUN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:13:27 -0400
Date: Thu, 17 Mar 2011 13:13:20 -0700
From: Greg KH <greg@kroah.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317201320.GB4035@kroah.com>
References: <201103111654.04089.arnd@arndb.de>
 <20110311160308.GQ1760@opensource.wolfsonmicro.com>
 <20110311161421.GA7843@kroah.com>
 <20110311162759.GS1760@opensource.wolfsonmicro.com>
 <20110311163522.GA9291@kroah.com>
 <20110311164850.GT1760@opensource.wolfsonmicro.com>
 <20110311165642.GA9996@kroah.com>
 <20110311170807.GV1760@opensource.wolfsonmicro.com>
 <20110311172345.GA10876@kroah.com>
 <alpine.LFD.2.00.1103162207130.26889@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103162207130.26889@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 10:14:01PM -0400, Nicolas Pitre wrote:
> > What drivers need this?  Specifics please.
> 
> Let me quote Arnd Bergmann:
> 
> |I have just verified with my Pandaboard that the pins on the SMSC9514
> |usb ethernet that are meant to be connected to a serial EEPROM are
> |indeed not connected anywhere.
> 
> > I would brand these types of systems "extremely broken" :)
> 
> Indeed.  But to hardware people, modifying the software is always cheaper.

Oh, I know this all too well.  I have lost months of my life to replace
a $0.05 part in a device in a past job :(

> > Anyway, specifics are the best way forward if anyone has such a messed
> > up system.
> 
> PandaBoards are becoming quite popular.

I have one right here.

But can't this device be detected by the usb device id and the quirk
added that way?  Like all other "odd" USB devices are currently handled?

thanks,

greg k-h
