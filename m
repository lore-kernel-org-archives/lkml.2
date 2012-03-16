Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032803Ab2CPOVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:21:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46939 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031169Ab2CPOVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:21:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 Mar 2012 15:20:37 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>,
        <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: sd_revalidate_disk oops (was Re: Couple of Oops with kernel
 3.3-rc6)
Message-ID: <20120316152037.2cbb03b2@stein>
In-Reply-To: <20120305142557.52e0a087@stein>
References: <1330892889.2487.6.camel@firefly>
	<20120305142557.52e0a087@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 05 Stefan Richter wrote:
> On Mar 04 Nathan A. Mourey II wrote at LKML:
> > Hello all,
> > 
> > 	I just booted up 3.3.0-rc6 and received the following oopses.  Please
> > email if you need more info.
> 
> According to http://www.spinics.net/lists/linux-scsi/msg57814.html, fixes
> for this are meant to appear in the mainline kernel soon.

Nathan, Linus merged respective fixes last Wednesday night.
-- 
Stefan Richter
-=====-===-- --== =----
http://arcgraph.de/sr/
