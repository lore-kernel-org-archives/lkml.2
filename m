Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030891Ab2CFPBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:01:12 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57233 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030778Ab2CFPBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:01:10 -0500
X-Sasl-enc: 6VJH9wTtnOlVFRYNDf/X0Tub4EuDfJDI0aA6JgW/VPSA 1331046062
Date: Tue, 6 Mar 2012 06:58:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH][linux-next][RESEND] usb/gadget/pch_udc: Fix compile error
Message-ID: <20120306145817.GA2947@kroah.com>
References: <20120305164308.GE2459@kroah.com>
 <1331002144-30113-1-git-send-email-tomoya.rohm@gmail.com>
 <CANKRQng9mXsotS=Lq9QwwmXWEdfrwPUcTdxvjOf56uXe7APMiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQng9mXsotS=Lq9QwwmXWEdfrwPUcTdxvjOf56uXe7APMiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 03:39:37PM +0900, Tomoya MORINAGA wrote:
> Hi
> 
> Add information.
> 
> My develop environment is on x86.
> 
> According to following report,
>   http://kisskb.ellerman.id.au/kisskb/buildresult/5771890/
>   http://kisskb.ellerman.id.au/kisskb/buildresult/5771905/
> 
> This occurred on sparc64.
> 
> I suspect this issue ins GPIO implementation for sparc64.
> Does sparc64 support GPIO interrupt ?
> (Even x86, before 2.6.39, GPIO interrupt is not implemented !)
> 
> Additionally, this driver is for companion chip of Intel Atom E6xx series.
> So, this driver is never used for except x86, e.g. sparc.

Then the Kconfig file should probably only enable it on x86 to prevent
these kinds of things :)

thanks,

greg k-h
