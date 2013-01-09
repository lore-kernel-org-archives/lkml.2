Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3AIOTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:19:54 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37675 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3AIOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:19:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130109135006.GO19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
	<1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1357719435-29955-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130109135006.GO19691@intel.com>
Date: Wed, 9 Jan 2013 19:49:52 +0530
Message-ID: <CAKohpokJGXKZ9jonGtYvTnPNLVr=wjhQ0DN_e=PF=U3nvusp-A@mail.gmail.com>
Subject: Re: [resend][PATCH 03/16] dmaengine: introduce is_slave_xfer function
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n 9 January 2013 19:20, Vinod Koul <vinod.koul@intel.com> wrote:
>> +static inline bool is_slave_xfer(enum dma_transfer_direction direction)
>> +{
>> +     return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
>> +}
> After reading the subsequent patch I understand what is intent here. Perhaps
> is_slave_dirn() would have been a beter one...

dirn isn't readable, it took me some time to understand the intent...
Either have xfer or direction :)
