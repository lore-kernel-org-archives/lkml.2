Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2IEAJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:09:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50037 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2IEAJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:09:20 -0400
Date: Tue, 4 Sep 2012 17:02:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Drivers: hv: kvp: Copy the address family information
Message-ID: <20120905000230.GA31997@kroah.com>
References: <1346797219-25885-1-git-send-email-kys@microsoft.com>
 <20120904225655.GA3725@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9309DFF92@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9309DFF92@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 11:36:30PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Tuesday, September 04, 2012 6:57 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; ben@decadent.org.uk
> > Subject: Re: [PATCH 1/1] Drivers: hv: kvp: Copy the address family information
> > 
> > On Tue, Sep 04, 2012 at 03:20:19PM -0700, K. Y. Srinivasan wrote:
> > > Copy the address family information.
> > 
> > Why?
> 
> This is part of the IP injection protocol in that the host expects this field to reflect what addresses
> (address families) are currently bound to the interface. The KVP daemon is currently collecting this 
> Information and sending it to the kernel component. I had overlooked copying this and sending it
> back to the host. This patch addresses this issue.

That's nice and descriptive, any reason you didn't put it in the patch
changelog section the first time?

Please redo this...

greg k-h
