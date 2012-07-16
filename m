Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2GPPTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:19:45 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40647 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2GPPTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:19:44 -0400
Date: Tue, 17 Jul 2012 00:19:37 +0900
From: Norbert Preining <preining@logic.at>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: regression 918227bb -> -rc7: does not wake up from sleep
Message-ID: <20120716151937.GA29589@gamma.logic.tuwien.ac.at>
References: <20120716132705.GC21748@gamma.logic.tuwien.ac.at> <50041A4A.2000206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50041A4A.2000206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Mo, 16 Jul 2012, Srivatsa S. Bhat wrote:
> Not sure if this is the same problem, but here is a discussion around
> a recent commit that broke resume. May be you can try out that patch?
> 
> https://lkml.org/lkml/2012/7/16/113

Yes, works for me, too.

Thanks, and sorry for the noise.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
Having been erased,
The document you're seeking
Must now be retyped.
                       --- Windows Error Haiku
