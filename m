Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab1CCVxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:53:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53177 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab1CCVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:53:20 -0500
Date: Thu, 3 Mar 2011 13:51:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lud <linux-usb@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for February 21 (usb/serial)
Message-Id: <20110303135152.c4b53da1.randy.dunlap@oracle.com>
In-Reply-To: <201102212130.01789.rjw@sisk.pl>
References: <20110221182134.09abd232.sfr@canb.auug.org.au>
	<20110221095732.b3842652.randy.dunlap@oracle.com>
	<201102212130.01789.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D700DBD.0138,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011 21:30:01 +0100 Rafael J. Wysocki wrote:

> On Monday, February 21, 2011, Randy Dunlap wrote:
> > On Mon, 21 Feb 2011 18:21:34 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20110218:
> > 
> > 
> > When CONFIG_PM_RUNTIME is not enabled:
> > 
> > drivers/usb/serial/usb_wwan.c:702: error: 'struct dev_pm_info' has no member named 'usage_count'
> 
> This looks like a bug in the driver that shouldn't access this field directly.


This build error is still with us in linux-next 2011.0303.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
