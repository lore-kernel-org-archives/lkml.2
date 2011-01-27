Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1A0IWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 03:22:37 -0500
Received: from skl2.ukl.uni-freiburg.de ([193.196.199.2]:40245 "EHLO
	relay2.uniklinik-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab1A0IWg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 03:22:36 -0500
Subject: Re: Linux 2.6.37 x86 ncpfs regression: kernel BUG at
 include/linux/dcache.h:340 with >1366 files in directory
From: "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        david@fromorbit.com, npiggin@gmail.com
In-Reply-To: <alpine.DEB.2.01.1101261457480.7903@trent.utfs.org>
References: <1296053700.2684.19.camel@pst15.ukl.uni-freiburg.de>
	 <20110126163203.GP22723@ZenIV.linux.org.uk>
	 <1296061412.2684.59.camel@pst15.ukl.uni-freiburg.de>
	 <1296062778.2674.2.camel@pst15.ukl.uni-freiburg.de>
	 <alpine.DEB.2.01.1101261457480.7903@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 09:22:27 +0100
Message-ID: <1296116547.19078.22.camel@pst15.ukl.uni-freiburg.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
X-NAI-Spam-Flag: NO
X-NAI-Spam-Level: *
X-NAI-Spam-Threshold: 5
X-NAI-Spam-Score: 1.2
X-NAI-Spam-Report: 3 Rules triggered
	*  1 -- FROM_ALIAS_QUOTES_EVOL_2
	*  0.2 -- RCVD_FROM_BY_ENVFRM_1_AT_2
	*  0 -- RV3749
X-NAI-Spam-Version: 2.2.0.9286 : core <3749> : streams <589680> : uri
 <788737>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hasn't there been an earlier 
> attempt[0] to remove 3825bdb7ed920845961f32f364454bee5f469abb back in Nov 
> 2010?
> 
> Christian.
> 
> [0] http://www.gossamer-threads.com/lists/linux/kernel/1308598

It obviously didn't make it into 2.6.37. All I can say is that the bug
is 100% reproducible here by the procedure I outlined. And reading large
directories on ncpfs is as solid as it was in 2.6.36 if only this
dcache.c change is reverted. So I'm of course glad Nick's patch made it
into the tree now and would vote for its inclusion in 2.6.37-1.
I posted this because I didn't find a similar bug report. Or did I
overlook it?

Thanks and best regards,
Bernd
