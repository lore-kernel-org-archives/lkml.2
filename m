Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1LSRuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:50:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:9206 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1LSRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:50:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87329688"
Date: Mon, 19 Dec 2011 18:54:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH RESEND 1/3] mfd: Fix checking bit_mask for
 adp5520_set_bits
Message-ID: <20111219175457.GV11800@sortiz-mobl>
References: <1324295757.3350.3.camel@phoenix>
 <CAF+7xWmHa1ef2nd0g7Gf+rjsxUemapSLK_uwHxYnNws2dy9h_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWmHa1ef2nd0g7Gf+rjsxUemapSLK_uwHxYnNws2dy9h_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Dec 19, 2011 at 08:25:27PM +0800, Axel Lin wrote:
> 2011/12/19 Axel Lin <axel.lin@gmail.com>:
> > Current code checks if all the bit_mask bits are all zero is wrong.
> > We need to write new value if old value is not equal to new value.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> > ---
> > Hi Samuel,
> > I found this serial of patches are not merged yet.
> > ( although you replied that you applied all 3 patches in the mail )
> > It was post on https://lkml.org/lkml/2011/10/30/137
> > So I resend it again.
> >
> Hi Samuel,
> I found these patches already in your for-linus branch.
> But it is strange that these patches are not exist in linux-next tree.
Strange as in I forgot to cherry pick them. It should be fixed now, sorry.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
