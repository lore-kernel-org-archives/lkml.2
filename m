Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab1L0UqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 15:46:13 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:24988 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1L0UqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 15:46:10 -0500
MIME-Version: 1.0
Message-ID: <98bc4ff9-07bd-44ab-bb25-156c04d8f1e1@default>
Date: Tue, 27 Dec 2011 12:34:37 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Kurt Hackel <kurt.hackel@oracle.com>, sjenning@linux.vnet.ibm.com,
        Chris Mason <chris.mason@oracle.com>
Subject: RE: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging
 foundation
References: <20111222155050.GA21405@ca-server1.us.oracle.com>
 <20111222173129.GB28856@kroah.com>
 <1f76c37d-15d4-4c62-8c64-8293d3382b4a@default>
 <20111222224059.GA16558@kroah.com>
In-Reply-To: <20111222224059.GA16558@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EFA2E8B.008C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> 
> Ok, that makes sense.
> 
> Can you ensure that the TODO file in this driver's directory says that
> you will remove the duplicated code from it before it can be merged into
> the main part of the kernel tree?
> 
> That, and fix up the other things mentioned and resend it and I'll be
> glad to queue it up.

Done and reposted, but....

ARGH! Greg, somehow I left your direct email address off of the To list
for the repost!  Will you be able to get them from the drivers (or mm
or lkml) list, or will you need me to re-post them (just to you or
also again to the same To list?)

Sorry,
Dan

P.S. V3 starts with: https://lkml.org/lkml/2011/12/27/158 or
http://driverdev.linuxdriverproject.org/pipermail/devel/2011-December/023736.html 

