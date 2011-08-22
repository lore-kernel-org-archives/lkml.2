Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1HVP0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:26:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21421 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1HVP0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:26:16 -0400
Date: Mon, 22 Aug 2011 11:23:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: greg@kroah.com, stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com
Subject: Please back-port git commit 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9
 and 89153b5cae9f40c224a5d321665a97bf14220c2c to 3.0.x
Message-ID: <20110822152354.GA24763@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E527495.0069:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

I've two patches that are in Linus's upstream kernel, but I neglected to
put the stable@kernel.org on them (duh!). Both Fedora and Ubuntu are carrying
those two patches - but it would be nice if other distros got them.

The two patches are:

commit 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9
Author: Stefan Bader <stefan.bader@canonical.com>
Date:   Thu Jul 14 15:30:22 2011 +0200

    xen-blkfront: Drop name and minor adjustments for emulated scsi devices

commit 89153b5cae9f40c224a5d321665a97bf14220c2c
Author: Stefan Bader <stefan.bader@canonical.com>
Date:   Thu Jul 14 15:30:37 2011 +0200

    xen-blkfront: Fix one off warning about name clash

Please back-port them to 3.0.x kernel. Thank you!

