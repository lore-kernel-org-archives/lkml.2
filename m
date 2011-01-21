Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1AUP14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:27:56 -0500
Received: from void.printf.net ([89.145.121.20]:52558 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab1AUP1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:27:54 -0500
Date: Fri, 21 Jan 2011 15:27:50 +0000
From: Chris Ball <cjb@laptop.org>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
Message-ID: <20110121152750.GA32551@void.printf.net>
References: <20110120075556.GA23566@intel.com> <20110120161248.GA11774@void.printf.net> <5D8008F58939784290FAB48F5497519835341813A7@shsmsx502.ccr.corp.intel.com> <20110121080422.GA21763@void.printf.net> <5D8008F58939784290FAB48F549751983539F50558@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D8008F58939784290FAB48F549751983539F50558@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuanxiao,

On Fri, Jan 21, 2011 at 05:12:00PM +0800, Dong, Chuanxiao wrote:
> I have used the checkpatch.pl to check this patch, and no error or warning found....

Oh, you're right!  I wonder if that's because it's in a .txt file rather
than a source file.  Not sure how to get it to warn about this, then.

> > Ah, I wasn't clear -- I meant the bytes/kilobytes units, not the data type
> > sizes.  e.g.:
> > 
> > +   size_t          enhanced_area_size;             /* Units: KB */
> I think the units of _offset and _size should be easy for user to understand, so just choose the Byte for _offset and Kbyte for _size...
> And as spec said, the _size is (ENH_SIZE_MULT_2 << 16 + ENH_SIZE_MULT_1 << 8 + ENH_SIZE_MULT_0) x HC_WP_GRP_SIZE x HC_ERASE_GPR_SIZE x 512kBytes. It must be Kbytes aligned. That is another reason to choose it.

I agree that we we should use these units, I'm just arguing that we
might as well mention them in the comment area.  The other card.h
definitions mention their unit sizes too.  At the moment your comments
for card.h simply repeat the variable name, which isn't useful -- why
not make them repeat some useful and not-necessarily-obvious information
instead?

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
