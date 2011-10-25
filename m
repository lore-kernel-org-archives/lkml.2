Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1JYI3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:29:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50137 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1JYI3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:29:33 -0400
Date: Tue, 25 Oct 2011 10:29:29 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        jic23@cam.ac.uk, aghayal@codeaurora.org, david@hardeman.nu,
        Shubhrajyoti@ti.com, saaguirre@ti.com, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 4/6] input/cma3000_d0x: Add CMA3000 spi support
Message-ID: <20111025082929.GC4605@ponder.secretlab.ca>
References: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
 <1319487676-27181-5-git-send-email-ricardo.ribalda@gmail.com>
 <20111024213635.GB4394@ponder.secretlab.ca>
 <CAPybu_3pF6u10JMmcbho1e7=8EPHMq8LQ1+uHpyVMOmbRMUsHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPybu_3pF6u10JMmcbho1e7=8EPHMq8LQ1+uHpyVMOmbRMUsHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 09:24:48AM +0200, Ricardo Ribalda Delgado wrote:
> Hello Grant
> 
>   Thanks for your comments. I am fixing the  --- problem in all the patches.
> 
> >
> > Mark Brown had posted a generic indirect register read/write library
> > that I believe is getting merged.  Maybe this driver should be using
> > it?
> 
> It is not on linux-next, and also it cannot be used directly, in order
> to read you have to do set reg= (reg << 2) | 2; And AFAIK it is not
> supported by the regmap
> 
> >
> > Drop the .bus line.  The core code does this bit for you.
> 
> Done
> 
> >> +module_init(cma3000_spi_init);
> >> +module_exit(cma3000_spi_exit);
> >
> > move module_init() directly below the function it registers.
> 
> Also done, but I believe the other is more elegant :)

:-p

g.

> >
> >> +
> >> +MODULE_DESCRIPTION("CMA3000-D0x Accelerometer SPI Driver");
> >> +MODULE_LICENSE("GPL");
> >> +MODULE_AUTHOR("Ricardo Ribalda <ricardo.ribalda@gmail.com>");
> >> --
> >> 1.7.7
> >>
> >
> 
> 
> 
> -- 
> Ricardo Ribalda
