Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1IRPFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 11:05:50 -0400
Received: from ns.theshore.net ([67.18.92.50]:48994 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab1IRPFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 11:05:49 -0400
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0 Xen pv guest - BUG: Unable to handle]
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: "Christopher S. Aker" <caker@theshore.net>
In-Reply-To: <4E724F64.5080103@theshore.net>
Date: Sun, 18 Sep 2011 11:05:33 -0400
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CEE295A1-B386-4A2A-A16C-9AC29DE174E8@theshore.net>
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>	<4E5BA49D.5060800@theshore.net>	<20110829150734.GB24825@dumpdata.com>	<1314704744.28989.2.camel@zakaz.uk.xensource.com>	<4E5E9CDB.3070706@theshore.net>	<20110906171319.GB29839@dumpdata.com>	<4E6E2E11.1030602@theshore.net> <20110912161127.GB16100@oracle.com> <4E724ACD.1050207@theshore.net> <4E724F64.5080103@theshore.net>
To: "Christopher S. Aker" <caker@theshore.net>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've discovered a way to reproduce this quite easily!  Fire up a guest, run eatmem with 1M and enough threads to not OOM.

http://www.theshore.net/~caker/uml/patches/utils/eatmem.c

On a 1G guest: ./eatmem 1M 900

-Chris

