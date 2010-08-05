Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab0HESSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:18:20 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47318 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252Ab0HESSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:18:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
Date: Thu, 5 Aug 2010 11:17:58 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201193609@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <C9528078-D64C-4944-B960-0E985B3EE0BA@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
Thread-Index: Acs0x5rSJ4s7P9ssRjKYVWxFQe3GMgAARQEw
References: <20100308191005.GE4324@amak.tundra.com> <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com> <AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com> <4381.1280815590@neuling.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520114309D@CORPEXCH1.na.ads.idt.com> <AANLkTinpwYnyc1oN1VbtBgUF6bk6E5q_Gq1Dj3WXV3wc@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552011430BC@CORPEXCH1.na.ads.idt.com> <26581.1280979260@neuling.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011935BD@CORPEXCH1.na.ads.idt.com> <C9528078-D64C-4944-B960-0E985B3EE0BA@kernel.crashing.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: "Michael Neuling" <mikey@neuling.org>, "Timur Tabi" <timur@freescale.com>,
        "Alexandre Bounine" <abounine@tundra.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <thomas.moll@sysgo.com>, "Li Yang-R58472" <r58472@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm looking at this now and wondering what we added the mcheck handler
for in the first place and what
> its trying to accomplish.
> 
> - k

This protects system from hanging if RIO link fails or enters error
state. In some situations following maintenance read may initiate link
recovery from error state.

As it is now, MCheck mostly prevents system from hanging, but it also
adds sense to return status of maintenance read routine. I am using
return status in my new set of patches to check if RIO link is valid
during error recovery.

Alex.

 
