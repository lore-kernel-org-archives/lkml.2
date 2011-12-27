Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab1L0UaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 15:30:10 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:31736 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1L0UaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 15:30:07 -0500
MIME-Version: 1.0
Message-ID: <7866f872-ce94-4516-bd23-936ea3d0b4e3@default>
Date: Tue, 27 Dec 2011 12:29:46 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Kurt Hackel <kurt.hackel@oracle.com>, sjenning@linux.vnet.ibm.com,
        Chris Mason <chris.mason@oracle.com>
Subject: RE: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging
 foundation
References: <20111222155050.GA21405@ca-server1.us.oracle.com>
 <243729.1325016332@turing-police.cc.vt.edu>
In-Reply-To: <243729.1325016332@turing-police.cc.vt.edu>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EFA2AC6.0024,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Sent: Tuesday, December 27, 2011 1:06 PM
> To: Dan Magenheimer
> Cc: greg@kroah.com; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> ngupta@vflare.org; Konrad Wilk; Kurt Hackel; sjenning@linux.vnet.ibm.com; Chris Mason
> Subject: Re: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging foundation
> 
> On Thu, 22 Dec 2011 07:50:50 PST, Dan Magenheimer said:
> 
> > Copy cluster subdirectory from ocfs2.  These files implement
> > the basic cluster discovery, mapping, heartbeat / keepalive, and
> > messaging ("o2net") that ramster requires for internode communication.
> 
> Instead of doing this, can we have the shared files copied to a common
> subdirectory so that ramster and ocfs2 can share them, and we only
> have to fix bugs once?

Hi Valdis --

Thanks for your reply!

Per the discussion at:
https://lkml.org/lkml/2011/12/22/369 
your suggestion of the common subdirectory will definitely need to happen
before ramster can be promoted out of staging and, at GregKH's request,
I have added a TODO file in V3 to state that.  Before that can happen,
we'll need to work with the ocfs2 maintainers to merge the
necessary ramster-specific changes and implement a separately CONFIG-able
subdirectory for the ocfs2 cluster code.

Dan

