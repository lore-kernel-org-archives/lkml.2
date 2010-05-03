Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0ECTLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:11:49 -0400
Received: from kroah.org ([198.145.64.141]:49352 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab0ECTLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:11:37 -0400
Date: Mon, 3 May 2010 11:47:41 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: Dan Carpenter <error27@gmail.com>, gregkh@suse.de, penberg@cs.helsinki.fi,
       pavel@ucw.cz, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: phy_calibration.c Coding style fixes
 1/2.
Message-ID: <20100503184741.GD10778@kroah.com>
References: <1269267447-6245-1-git-send-email-lindley@coyote.org>
 <20100322142924.GA23411@bicker>
 <4BA783AA.8060108@coyote.org>
 <20100428233605.GD28878@kroah.com>
 <4BDD3B5C.2050508@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDD3B5C.2050508@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 02, 2010 at 10:44:12AM +0200, Lars Lindley wrote:
> On 2010-04-29 01:36, Greg KH wrote:
> > On Mon, Mar 22, 2010 at 03:50:18PM +0100, Lars Lindley wrote:
> >> On 2010-03-22 15:29, Dan Carpenter wrote:
> >>> On Mon, Mar 22, 2010 at 03:17:26PM +0100, Lars Lindley wrote:
> >>>> Whitespace and indentation fixes. Removed "commented away"
> >>>> code and revision comments.
> >>>> Checked with Dan Carpenters strip_whitespace.pl and diff.
> >>>> Compiles fine and .o file is identical before and after.
> >>>>
> >>>
> >>> 	[ snip ]
> >>>
> >>>> -#ifdef _DEBUG
> >>>> +	/* e. The result are shown in "adc_dc_cal_i[8:0] and adc_dc_cal_q[8:0]" */
> >>>> +	#ifdef _DEBUG
> >>>>  	hw_get_dxx_reg(phw_data, REG_OFFSET_READ, &val);
> >>>>  	PHY_DEBUG(("[CAL]    REG_OFFSET_READ = 0x%08X\n", val));
> >>>>  
> >>>>  	PHY_DEBUG(("[CAL]    ** adc_dc_cal_i = %d (0x%04X)\n",
> >>>> -			   _s9_to_s32(val&0x000001FF), val&0x000001FF));
> >>>> +			_s9_to_s32(val & 0x000001FF), val & 0x000001FF));
> >>>>  	PHY_DEBUG(("[CAL]    ** adc_dc_cal_q = %d (0x%04X)\n",
> >>>> -			   _s9_to_s32((val&0x0003FE00)>>9), (val&0x0003FE00)>>9));
> >>>> -#endif
> >>>> +			_s9_to_s32((val & 0x0003FE00) >> 9), (val & 0x0003FE00) >> 9));
> >>>> +	#endif
> >>>>  
> >>>
> >>> #ifdef and #endif shouldn't be indented.
> >>>
> >>> I'm really happy that you're using my script.  It feels more relaxing to 
> >>> review these when I know that no bugs were introduced.
> >>>
> >>> regard,
> >>> dan carpenter
> >>>
> >>
> >> Hi Dan.
> >>
> >> It feels good to me to.
> >> When you sit with repetitive editing for a couple of hours you're
> >> bound to make a mistake or two. :)
> >>
> >> I made a new patch that applies after these two that fixes the indentation.
> >> When we have acks for all the parts I can combine them into one patch.
> > 
> > Can you merge these together now?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Same here. Patch against phy-calibration.c including the other patches.

One hunk failed, and I don't have a signed-off-by: line anymore :(

Care to redo it cleanly?

thanks,

greg k-h
