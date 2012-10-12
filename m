Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab2JLOwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:52:54 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62037 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab2JLOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <20121012144837.GE12801@game.jcrosoft.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	<2039bc164224b0068bc078b6cd8df6218e754fce.1350051925.git.viresh.kumar@linaro.org>
	<20121012144837.GE12801@game.jcrosoft.org>
Date: Fri, 12 Oct 2012 20:22:52 +0530
Message-ID: <CAKohpo=vMchmiz70evBB5bPqt4O4DWUocd5M1o9gc8fsY_Fkiw@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] ARM: SPEAr13xx: Pass DW DMAC platform data from DT
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: vinod.koul@intel.com, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 20:18, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
>>  static struct of_dev_auxdata spear1310_auxdata_lookup[] __initdata = {
>> -     OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_dma_priv),
>> -     OF_DEV_AUXDATA("snps,dma-spear1340", DMAC0_BASE, NULL, &dmac_plat_data),
>> -     OF_DEV_AUXDATA("snps,dma-spear1340", DMAC1_BASE, NULL, &dmac_plat_data),
>> +     OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, "cf"),
> ?/

Sorry. can't get it :(
