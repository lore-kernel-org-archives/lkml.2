Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab1BUUaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:30:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44682 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab1BUUaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:30:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for February 21 (usb/serial)
Date: Mon, 21 Feb 2011 21:30:01 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, lud <linux-usb@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20110221182134.09abd232.sfr@canb.auug.org.au> <20110221095732.b3842652.randy.dunlap@oracle.com>
In-Reply-To: <20110221095732.b3842652.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102212130.01789.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 21, 2011, Randy Dunlap wrote:
> On Mon, 21 Feb 2011 18:21:34 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110218:
> 
> 
> When CONFIG_PM_RUNTIME is not enabled:
> 
> drivers/usb/serial/usb_wwan.c:702: error: 'struct dev_pm_info' has no member named 'usage_count'

This looks like a bug in the driver that shouldn't access this field directly.

Thanks,
Rafael
