Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2BCE3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 23:29:42 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58996 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2BCE3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 23:29:41 -0500
Date: Fri, 3 Feb 2012 13:29:01 +0900
From: Norbert Preining <preining@logic.at>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
	COMRESET failed
Message-ID: <20120203042900.GA21988@gamma.logic.tuwien.ac.at>
References: <20120202051258.GA15550@gamma.logic.tuwien.ac.at> <4F2A4B7E.2090503@linux.vnet.ibm.com> <1328231716.15079.15.camel@minggr> <1328242884.15079.22.camel@minggr> <20120202051258.GA15550@gamma.logic.tuwien.ac.at> <4F2A4B7E.2090503@linux.vnet.ibm.com> <1328231716.15079.15.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328242884.15079.22.camel@minggr> <1328231716.15079.15.camel@minggr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 03 Feb 2012, Lin Ming wrote:
> Could you attach the full 3.3-rc2 dmesg?

Attached.

> First, you can check if commit 318893e is good or bad.

Will try.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
Another world, another day, another dawn.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
