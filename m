Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab2KPCVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:21:22 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39981 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2KPCVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:21:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121114155427.957923E0B1A@localhost>
References: <CAPgLHd_rNn_bJ8BJOwcq8EmEi-BQcoakHmQpHG+NdOdDgPSMpQ@mail.gmail.com>
	<20121114155427.957923E0B1A@localhost>
Date: Fri, 16 Nov 2012 10:21:19 +0800
Message-ID: <CAPgLHd-ouUjVdLKG331RX-Lh4bxKq2WfgXRfchoeV9_bSfTxpg@mail.gmail.com>
Subject: Re: [PATCH] spi: omap2-mcspi: remove duplicated include from spi-omap2-mcspi.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca
Cc: rob.herring@calxeda.com, yongjun_wei@trendmicro.com.cn,
        spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 11:54 PM, Grant Likely wrote:
> On Sun, 7 Oct 2012 21:29:21 +0800, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Remove duplicated include.
> Applied, thanks.
>
>> dpatch engine is used to auto generate this patch.
>> (https://github.com/weiyj/dpatch)
> Since I have to manually remove the above cruft from commit logs, can
> you please omit it from the commit text when posting patches?
>
> Thanks,
> g.

will do it, thanks.


