Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1KXScx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 13:32:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50614 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888Ab1KXScw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 13:32:52 -0500
Date: Thu, 24 Nov 2011 18:32:48 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Marcus Osdoba <marcus.osdoba@googlemail.com>, 649216@bugs.debian.org
Message-ID: <20111124183248.GV3366@decadent.org.uk>
References: <1322118279.2839.255.camel@deadeye>
 <20111124162426.GA4435@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124162426.GA4435@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] topology: Provide CPU topology in sysfs in !SMP
 configurations
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 08:24:26AM -0800, Greg KH wrote:
> On Thu, Nov 24, 2011 at 07:04:39AM +0000, Ben Hutchings wrote:
> > We should provide topology information to userland even if it's not
> > very interesting.  The current code appears to work properly for !SMP
> > (tested on i386).
> 
> Why, what will the topology look like for this?
 
physical_package_id: "-1"
core_id: "0"
thread_siblings: "1"
thread_siblings_list: "0"
core_siblings: "1"
core_siblings_list: "0"

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
