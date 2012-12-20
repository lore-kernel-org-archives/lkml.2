Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2LTGZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:25:32 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2LTGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:25:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="15485822"
Message-ID: <50D2AF54.7050402@codeaurora.org>
Date: Wed, 19 Dec 2012 22:25:24 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
CC: Paul Walmsley <paul@pwsan.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: spinlock bad magic on CPU#0 on BeagleBone
References: <B5906170F1614E41A8A28DE3B8D121433EC9A69C@DBDE01.ent.ti.com> <alpine.DEB.2.00.1212191650430.16873@utopia.booyaka.com> <50D2224E.4060300@codeaurora.org> <B5906170F1614E41A8A28DE3B8D121433EC9B6FE@DBDE01.ent.ti.com>
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EC9B6FE@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 8:48 PM, Bedia, Vaibhav wrote:
> I tried out 3 variants of AM335x boards - 2 of these (BeagleBone and EVM) have DDR2
> and 1 has DDR3 (EVM-SK). The BUG is triggered on all of these at the same point.
>
> With Stephen's change I don't see this on any of the board variants :)
> New bootlog below.

Great! Can I have your Tested-by then? I'll wrap it up into a patch. Is
this is a new regression? From a glance at the code it looks to have
existed for quite a while now.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

