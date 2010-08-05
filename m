Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab0HERxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:53:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:42447 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab0HERxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:53:50 -0400
Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552011935BD@CORPEXCH1.na.ads.idt.com>
Date: Thu, 5 Aug 2010 12:53:03 -0500
Cc: "Michael Neuling" <mikey@neuling.org>, "Timur Tabi" <timur@freescale.com>,
        "Alexandre Bounine" <abounine@tundra.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <thomas.moll@sysgo.com>, "Li Yang-R58472" <r58472@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C9528078-D64C-4944-B960-0E985B3EE0BA@kernel.crashing.org>
References: <20100308191005.GE4324@amak.tundra.com> <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com> <AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com> <4381.1280815590@neuling.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520114309D@CORPEXCH1.na.ads.idt.com> <AANLkTinpwYnyc1oN1VbtBgUF6bk6E5q_Gq1Dj3WXV3wc@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552011430BC@CORPEXCH1.na.ads.idt.com> <26581.1280979260@neuling.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011935BD@CORPEXCH1.na.ads.idt.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@IDT.COM>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 5, 2010, at 12:25 PM, Bounine, Alexandre wrote:

> Below is a copy of Leo's message with pointers to the patches.
> 
> Alex.
> 
>> Subject: [PATCH] RapidIO,powerpc/85xx: remove MCSR_MASK in fsl_rio
>> 
>> Fixes compile problem caused by MCSR_MASK removal from book-E
> definitions.
> 
> Hi Alex,
> 
> Only with your patch, there will still be problem on SRIO platforms
> other than MPC85xx.
> 
> I have posted a patch series to fix this together with several
> compatibility issues a month before.
> 
> http://patchwork.ozlabs.org/patch/56135/
> http://patchwork.ozlabs.org/patch/56136/
> http://patchwork.ozlabs.org/patch/56138/
> http://patchwork.ozlabs.org/patch/56137/
> 
> 
> Can anyone pick the patch series quickly as currently there is a compile
> error when SRIO is enabled.
> 
> - Leo

I'm looking at this now and wondering what we added the mcheck handler for in the first place and what its trying to accomplish.

- k
