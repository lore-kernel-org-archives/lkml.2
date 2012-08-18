Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2HRTKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 15:10:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22918 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2HRTKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 15:10:48 -0400
MIME-Version: 1.0
Message-ID: <875d22f4-47f4-4dc0-81b7-0a9da59b202d@default>
Date: Sat, 18 Aug 2012 12:10:08 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, minchan@kernel.org
Subject: RE: [PATCH 0/3] staging: zcache+ramster: move to new code base and
 re-merge
References: <1345156293-18852-1-git-send-email-dan.magenheimer@oracle.com>
 <20120816224814.GA18737@kroah.com>
 <9f2da295-4164-4e95-bbe8-bd234307b83c@default>
 <20120816230817.GA14757@kroah.com> <502EC67F.4070603@linux.vnet.ibm.com>
In-Reply-To: <502EC67F.4070603@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Seth re new redesigned codebase]

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Friday, August 17, 2012 4:33 PM
>
> So I can't support this patchset, citing the performance
> degradation and the fact that this submission is
> unreviewable due to it being one huge monolithic patchset on
> top of an existing codebase.

[Dan re old demo codebase]

> From: Dan Magenheimer
> Sent: Wednesday, August 08, 2012 11:48 AM
> Subject: RE: [PATCH 0/4] promote zcache from staging
> 
> Sorry, but FWIW my vote is still a NACK.  IMHO zcache needs major
> work before it should be promoted, and I think we should be spending
> the time fixing the known flaws rather than arguing about promoting
> "demo" code.

:-#

"Well, pahdner," drawls the Colorado cowboy (Dan) to the Texas
cowboy (Seth), "I reckon we gots us a good old fashioned standoff."

"What say we settle this like men, say six-shooters at
twenty paces?"

:-)

Seriously, maybe we should consider a fork?  Zcache and zcache2?

(I am REALLY away from email for a few days starting NOW.)

Dan
