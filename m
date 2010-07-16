Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935889Ab0GPHyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:54:53 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:60700 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935822Ab0GPHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:54:50 -0400
Date: Fri, 16 Jul 2010 10:54:40 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: ext Andy Shevchenko <andy.shevchenko@gmail.com>,
        Micha?? Nazarewicz <m.nazarewicz@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shevchenko Andriy (EXT-Teleca/Helsinki)" 
	<ext-andriy.shevchenko@nokia.com>,
        "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
        "Hunter Adrian (Nokia-MS/Helsinki)" <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
Message-ID: <20100716075439.GA25553@gandalf>
Reply-To: me@felipebalbi.com
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
 <1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>
 <op.vft2p6do7p4s8u@pikus>
 <AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com>
 <4C3DC1D5.4060406@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3DC1D5.4060406@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 14, 2010 at 04:55:33PM +0300, Roger Quadros wrote:
> file_storage driver does not deal with partitions. only mediums.

it deals with backing files, no matter if it's a medium, partition or a
file on a file system (using a loop-device).

-- 
balbi
