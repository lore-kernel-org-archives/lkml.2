Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2JLNoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:44:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35287 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab2JLNoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Vcte64KF5k5gDjMtyff8KsOof-yT7iVWc3Gz_ECL+0+Mw@mail.gmail.com>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	<91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
	<1350030203.10584.139.camel@smile>
	<CAOh2x=m8OVNfMm5Fn+cr9Gxuh6oyt+8d4n-bkG8Xiw5zGncLiA@mail.gmail.com>
	<CAHp75VffAwZjfQLf=wS+nBhiRoMFOoyPeUCfrzF1G=+Kh7HHTA@mail.gmail.com>
	<CAKohponxbjTTDMOA_0=MT36wRh1NpzTAH4LdkaE=Z-ahup4BFg@mail.gmail.com>
	<CAHp75Vcte64KF5k5gDjMtyff8KsOof-yT7iVWc3Gz_ECL+0+Mw@mail.gmail.com>
Date: Fri, 12 Oct 2012 19:14:19 +0530
Message-ID: <CAKohpo=qz-mAso=-xsiztQ-USHkiWpKjwpoVAwQEj8DaVJ2v=w@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 16:55, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>>  EXPORT_SYMBOL(dw_generic_filter);
> Could we change a name to be more precise, like dw_dma_generic_filter ?

Sure.
