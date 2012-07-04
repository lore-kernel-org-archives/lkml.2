Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2GDRqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 13:46:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40716 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2GDRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 13:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <1341420818.19870.10.camel@laptop>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
	<1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>
	<1341396293.2507.77.camel@laptop>
	<4FF46885.2090609@intel.com>
	<1341420818.19870.10.camel@laptop>
Date: Thu, 5 Jul 2012 01:46:50 +0800
X-Google-Sender-Auth: XaIoQinfElegRvOqou3yGHfXZR0
Message-ID: <CAAM7YA=UdSrNbaoidr+CKBUmth_Yxhvc5=WPxjeb-H9FchkRhg@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf/x86: Add Intel Nehalem-EX uncore support
From: "Yan, Zheng " <yanzheng@21cn.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 12:53 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-07-05 at 00:00 +0800, Yan, Zheng wrote:
>>
>> > Also, how can a single extra register require 192 bits of config space?
>> >
>> Some events in the M-Box and R-Box require programming up to 3 extra
>> registers. For example, the event 0x5 in the R-Box requires programming
>> extra registers XBR_SET1_MM_CFG, XBR_SET1_MATCH and XBR_SET1_MATCH.
>
> But shouldn't you then use 3 extra_reg instead of blowing up the one?
>
These 3 registers are within a logical set, are always used at the same time.
I think it's natural to use a single data structure to track them.

Regards
Yan, Zheng
