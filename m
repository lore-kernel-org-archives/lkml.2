Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1COPhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:37:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20378 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab1COPhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:37:04 -0400
Date: Tue, 15 Mar 2011 08:36:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, lud <linux-usb@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for February 21 (usb/serial)
Message-Id: <20110315083626.67d85f55.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.1103040953380.1812-100000@iolanthe.rowland.org>
References: <20110303135152.c4b53da1.randy.dunlap@oracle.com>
	<Pine.LNX.4.44L0.1103040953380.1812-100000@iolanthe.rowland.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D7F8781.00A7,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011 10:04:38 -0500 (EST) Alan Stern wrote:

> On Thu, 3 Mar 2011, Randy Dunlap wrote:
> 
> > On Mon, 21 Feb 2011 21:30:01 +0100 Rafael J. Wysocki wrote:
> > 
> > > On Monday, February 21, 2011, Randy Dunlap wrote:
> > > > On Mon, 21 Feb 2011 18:21:34 +1100 Stephen Rothwell wrote:
> > > > 
> > > > > Hi all,
> > > > > 
> > > > > Changes since 20110218:
> > > > 
> > > > 
> > > > When CONFIG_PM_RUNTIME is not enabled:
> > > > 
> > > > drivers/usb/serial/usb_wwan.c:702: error: 'struct dev_pm_info' has no member named 'usage_count'
> > > 
> > > This looks like a bug in the driver that shouldn't access this field directly.
> > 
> > 
> > This build error is still with us in linux-next 2011.0303.
> 
> Since Oliver added this bug in commit
> 16871dcac74c63227aa92e0012f3004a648c2062 (usb_wwan: error case of
> resume), he should be the person to fix it.  The logic there is not 
> clear to me; I don't know how it ought to be changed.  Would replacing 
> it with a call to usb_autopm_put_interface_no_suspend() be good enough?

Hi Oliver,

This build problem still happens with linux-next 2011.0315.
Please send a fix for it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
