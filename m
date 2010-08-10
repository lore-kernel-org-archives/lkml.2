Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0HJXUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 19:20:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46154 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0HJXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 19:20:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6070"; a="50440577"
Date: Tue, 10 Aug 2010 16:20:14 -0700
From: David Brown <davidb@codeaurora.org>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: Neil Leeder <nleeder@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 1/1] mouse: add qci touchpad driver
Message-ID: <20100810232014.GB21240@huya.qualcomm.com>
References: <1281126776-20014-1-git-send-email-nleeder@codeaurora.org>
 <4C5D3926.6050307@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5D3926.6050307@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 04:14:54PM +0530, Trilok Soni wrote:

> > +
> > +/*
> > + * Driver communicates over i2c to nuvoTon WPCE775x Embedded Controller,
> > + * which has touchpad attached through PS/2 interface.
> > + */
> 
> Why this driver is not developed through MFD architecture then? nuvoTon chip
> looks like multi-function chip, isn't it?

It is, in the sense that it does multiple things.  But, for this
particular device, it makes the keyboard available as an i2c device.
I don't see any particular reason to tie that to other functionality
that the chip provides.

David
