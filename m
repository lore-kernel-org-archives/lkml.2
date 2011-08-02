Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab1HBG07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 02:26:59 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:41560 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab1HBG05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 02:26:57 -0400
Date: Tue, 2 Aug 2011 09:26:21 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] The longterm Linux 2.6.35.14 kernel is released
Message-ID: <20110802062621.GA5893@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c20110801215908.GA11448@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

> A note on the 2.6.35.13 git tags & branches: when releasing 2.6.35.13 I made
> a mistake which resulted in the v2.6.35.13 tag being on a different
> branch than the master tree.  I decided the continue on the branch,
> not the tag, so you have to delete the v2.6.35.13 tag -- if you're
> using that -- and refetch the new tag. If you just use the "master" branch
> or the released patches/tarballs you don't need to do anything. Sorry about 
> that.

The master branch of the longterm/linux-2.6.35.y.git tree does not seem to 
include the v2.6.35.14 tag. How can I fetch v2.6.35.14 using git?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
