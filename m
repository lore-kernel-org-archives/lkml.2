Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2JPRmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:42:16 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38468 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab2JPRmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:42:13 -0400
Date: Tue, 16 Oct 2012 10:42:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Patil, Rachna" <rachna@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH RESEND 0/8] TI Touchscreen driver updates and Support for
 TSC/ADC MFD driver
Message-ID: <20121016174207.GA1833@core.coreip.homeip.net>
References: <1350372345-27108-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350372345-27108-1-git-send-email-rachna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rachna,

On Tue, Oct 16, 2012 at 12:55:37PM +0530, Patil, Rachna wrote:
> This patch set is a cumulative set of [1] and [2] sent earlier.
> I have merged the patch set so that the MFD patches apply without
> any issues.
> 
> Also Note that there are no code changes in either of the patch set,
> only rebased on top of linux-next to make sure that all the patches
> apply without any conflicts.
> 
> This patch set has been tested on AM335x EVM.
> 
> [1] "[PATCH 0/4] input: TSC: ti_tscadc: TI Touchscreen driver updates"
> (http://www.spinics.net/lists/linux-input/msg22107.html)
> 
> [2] "[PATCH v5 0/4] Support for TSC/ADC MFD driver"
> (http://www.spinics.net/lists/linux-input/msg22832.html)
> 
> Patil, Rachna (8):
>   input: TSC: ti_tscadc: Correct register usage
>   input: TSC: ti_tscadc: Add Step configuration as platform data
>   input: TSC: ti_tscadc: set FIFO0 threshold Interrupt
>   input: TSC: ti_tscadc: Remove definition of End Of Interrupt register
>   input: TSC: ti_tscadc: Rename the existing touchscreen driver
>   MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
>   input: TSC: ti_tsc: Convert TSC into a MFDevice
>   IIO : ADC: tiadc: Add support of TI's ADC driver

I am fine with input portion of the patch series, please merge through
MFD tree.

Thanks.

-- 
Dmitry
