Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2GXJlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:41:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:18751 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab2GXJlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:41:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="184831501"
Date: Tue, 24 Jul 2012 10:58:22 +0100
From: Alan Cox <alan@linux.intel.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ian Abbott <ian.abbott@mev.co.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Oops after merge of tty-next
Message-ID: <20120724105822.22b90e94@bob.linux.org.uk>
In-Reply-To: <500D64D7.3060902@mev.co.uk>
References: <5009D68A.3050301@mev.co.uk>
	<20120721234145.354e6ee9@pyramind.ukuu.org.uk>
	<500D64D7.3060902@mev.co.uk>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry for the late reply.  I'm using Gentoo Linux built from source
> for ~amd64 (unstable).

Thanks

> The crashes all seem to be while the devfs process is running.  One 
> thing strange I noticed is that I'm using Gentoo's "OpenRC" boot
> system, but the crashes only occur when it is configured to start
> services in parallel (rc_parallel="YES" in /etc/rc.conf).

I've not managed to duplicate this yet but I suspect there is a
locking bug in one of the paths where devfs is opening the tty
multiple times in parallel.

I may have to try building a stress tester for that.

Alan
 

