Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab2GKMIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:08:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36556 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2GKMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:08:10 -0400
MIME-Version: 1.0
In-Reply-To: <1342000654.3462.137.camel@twins>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
	<1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>
	<1341396293.2507.77.camel@laptop>
	<4FF534F1.3030307@intel.com>
	<1341922621.3462.130.camel@twins>
	<4FFCDF8C.9060204@intel.com>
	<1342000654.3462.137.camel@twins>
Date: Wed, 11 Jul 2012 20:02:51 +0800
X-Google-Sender-Auth: PVrkCq_ue1XRP6L_iHXSiSMWDPA
Message-ID: <CAAM7YA=M37jpM+XnY6caevO7Fv512_8OgPfiMKYPHrkx_XCDhA@mail.gmail.com>
Subject: Re: [PATCH V2 5/5] perf/x86: Add Intel Nehalem-EX uncore support
From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 5:57 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-07-11 at 10:06 +0800, Yan, Zheng wrote:
>> This doesn't work. The MSRs for Cbox 8/9 in WSM-EX aren't contiguous with
>> Cbox 0~7.
>
> Argh!
>
>>  Furthermore the encoding for the FVC register in the Mbox are
>> different between NHM-EX and WSM-EX.
>
> OK, 18.7.1 from Vol. 3B doesn't mention that.. where did you find this?
>

Table 2-80 in <<Intel Xeon Processor 7500 Series Uncore Programming Guide>> and
<<Intel Xeon Processor E7 Family Uncore Performance Monitoring
Programming Guide>>.
The fvid field in NHM-EX is 5 bits, in WSM-EX is 6 bits.

Thanks
Yan, Zheng
