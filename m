Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3ADTyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:54:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41688 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab3ADTym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:54:42 -0500
MIME-Version: 1.0
Message-ID: <ea7e4623-0983-4b1d-9d0d-8a523669adca@default>
Date: Fri, 4 Jan 2013 11:53:37 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [RFC/PATCH] drivers/staging/zcache: remove (old) zcache
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Seth Jennings has moved on to zswap [1], I believe further
effort on the older version of zcache has been abandoned.
Unless there are objections, I can submit a patch to
Greg to remove drivers/staging/zcache and, at some point,
follow up with a patch to re-invert drivers/staging/ramster
so that the newer version of zcache (aka zcache2) becomes
drivers/staging/zcache, with ramster as a subdirectory.

If I've missed anyone on the cc list who possibly cares about
the old version of zcache, kindly forward.

Greg, assuming no objections, do you want an official patch,
i.e. removing each individual line of each file in
drivers/staging/zcache?  Or will you just do a git rm?
If the latter and you need a SOB, I am the original author so:
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com> 

[1] https://lkml.org/lkml/2012/12/12/310 

Thanks,
Dan
