Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2FYEyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:54:53 -0400
Received: from linux-sh.org ([111.68.239.195]:57504 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab2FYEyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:54:51 -0400
Date: Mon, 25 Jun 2012 13:54:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: error: implicit declarations of BUG/BUG_ON/WARN_ON/WARN_ON_ONCE
Message-ID: <20120625045438.GA24033@linux-sh.org>
References: <20120615143303.3b88edcbc3efc7b1bf81839b@canb.auug.org.au>
 <20120615065231.GA12272@localhost>
 <4FDB6261.2030400@xenotime.net>
 <4FDF5D50.7030505@xenotime.net>
 <20120622071305.GA15102@localhost>
 <20120625025301.GB9317@linux-sh.org>
 <20120625042017.GA11705@localhost>
 <4FE7E7CA.2030706@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE7E7CA.2030706@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 09:23:38PM -0700, Randy Dunlap wrote:
> On 06/24/2012 09:20 PM, Fengguang Wu wrote:
> 
> > Hi Paul,
> > 
> > The patch builds fine, thank you!
> > 
> > Tested-by: Fengguang Wu <wfg@linux.intel.com>
> 
> 
> You clearly have better build hardware than I do (a simple Core i5
> laptop).  ;)
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks.
> 
Great, I'll send it off to Linus, thanks for testing.
