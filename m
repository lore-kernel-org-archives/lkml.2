Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0H3Dt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:49:27 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51848 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0H3Dt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:49:26 -0400
Date: Sun, 29 Aug 2010 23:51:00 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
        Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        grant.likely@secretlab.ca,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 0/9] add OLPC device-tree support
Message-ID: <20100829235100.6dcedcb8@debxo>
In-Reply-To: <20100628215407.2017bf2f@debian>
References: <20100628215407.2017bf2f@debian>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches modify drivers/of, sparc, and x86 accordingly to add
OLPC device-tree support.  Updates have been made based upon Grant and
Davem's comments.  They've been compile-tested on sparc64 and x86, and
runtime tested on OLPC machines.

Dave's 25edd6946 commit caused some conflicts w/ patch #2;
hopefully I mangled it properly.
