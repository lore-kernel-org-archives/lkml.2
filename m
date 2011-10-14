Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1JNQRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:17:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:48121 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1JNQRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:17:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="63304675"
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
In-Reply-To: <CAGsJ_4y5m8G9MTi4q=CnpjtF4cyJWOVa6Xf-J+JQYo6MLHhUKQ@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	 <CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
	 <CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
	 <1318599079.1546.395.camel@vkoul-udesk3>
	 <CAGsJ_4zSKwSm-En0TCacMTPhRG_YCaOC=aWcxF7rXWq26JcKuQ@mail.gmail.com>
	 <1318604775.1546.418.camel@vkoul-udesk3>
	 <CAGsJ_4y5m8G9MTi4q=CnpjtF4cyJWOVa6Xf-J+JQYo6MLHhUKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 21:39:20 +0530
Message-ID: <1318608560.1546.436.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 23:38 +0800, Barry Song wrote:
> Vinod, actually it is not decided by codec. it is only related with
> the hardware of pcm, i2s or AC'97 controllers in SoC. i did remember
> some people  once licensed a TDM tranfer enginee from synopsys and IC
> guys bound one TDM slot, which has a seperate  dma channel, to one
> audio channel then organize several TDM slots into a AC97 controller.
Not sure if I follow you.
For i2s and pcm you send left/right channel and then right/left channel.
Data is sent interleaved. DMA also treats it same way.
I don't know about AC97 so wont comment about it
> 
> i am on holiday now and i can't give you more information until next
> week.
> 
> Still i saw most other chips binding multi-channels of an I2S/PCM/AC97
> audio controller in a dma channel, then it doesn't need interleaved
> dma api as its dma address will increase continuously. dma will
> transfer left+right together but not one left and one right.
Right :)

-- 
~Vinod

