Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2BFClG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 21:41:06 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40450 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2BFClD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 21:41:03 -0500
Date: Mon, 6 Feb 2012 11:40:52 +0900
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
Message-ID: <20120206024052.GI9413@gamma.logic.tuwien.ac.at>
References: <20120202051258.GA15550@gamma.logic.tuwien.ac.at> <4F2A4B7E.2090503@linux.vnet.ibm.com> <1328231716.15079.15.camel@minggr> <1328242884.15079.22.camel@minggr> <20120203052452.GC24563@gamma.logic.tuwien.ac.at> <1328247269.15079.26.camel@minggr> <20120203054319.GA25510@gamma.logic.tuwien.ac.at> <1328257660.15079.30.camel@minggr> <20120206004608.GA9413@gamma.logic.tuwien.ac.at> <1328492218.15079.38.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328492218.15079.38.camel@minggr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 06 Feb 2012, Lin Ming wrote:
> > > Anyway, does below DEBUG patch help?
> > > Let's always stop the engine during hard reset.
> > 
> > If you meant: 
> >   "Try that patch on top of HEAD *without* reverting 7faa33da9b7?"
> > then I can report that it does NOT help. With *only* this patch I still
> > get 10sec delay, and otherwise nothing changes.
> 
> Does below help?

In which combination - with or without the first patch?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HERSTMONCEUX (n.)
The correct name for the gold medallion worn by someone who is in the
habit of wearing their shirt open to the waist.
			--- Douglas Adams, The Meaning of Liff
