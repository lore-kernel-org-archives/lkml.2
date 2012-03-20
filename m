Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab2CTBdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:33:41 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54978 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab2CTBdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:33:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120320002955.GA26604@codeaurora.org>
References: <CADvmyBeNXHgknSUJazJY5EVueZHMcqJ7FpVEZT8kkv-bzb+F0w@mail.gmail.com>
	<20120320002955.GA26604@codeaurora.org>
Date: Tue, 20 Mar 2012 09:33:38 +0800
Message-ID: <CADvmyBdAzmBUC-uhhU9=HcyhAk214bw5_xZtaQxWU223THwkQA@mail.gmail.com>
Subject: Re: How about the MMC/SDIO host controller standard under Linux ?
From: "peter.meng" <mengsanshui@gmail.com>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks David


On Tue, Mar 20, 2012 at 8:29 AM, David Brown <davidb@codeaurora.org> wrote:
> On Mon, Mar 19, 2012 at 10:39:29AM +0800, peter.meng wrote:
>
>> I see the drivers/mmc/host/sdhci.h define the common register as
>> describe within
>> Part_A2_SD_Host_Controller_Simplified_Specification_Ver3.00_Final_110225.pdf
>> In this case all command related access register is common .(sdhci-xxx.c)
>> Does this mean all sdhci-xxx.c that will support SD host controller  standard ?
>
>> I see most code  such as s3cmci.c ,msm_sdcc.c that has their only
>> private register that access by such as mmc_host_ops->request function
>> .
>> I want to know whether this mean these host controller doesn't support
>>  SD host controller standard ?
>
> There are numerous SD host controllers that aren't SDHCI.
>
> David
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
