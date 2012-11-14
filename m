Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab2KNWtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:49:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36050 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab2KNWtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:49:40 -0500
Date: Wed, 14 Nov 2012 17:49:38 -0500 (EST)
Message-Id: <20121114.174938.1893866220809474233.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] drivers/of: Constify device_node->name and
 ->path_component_name
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACxGe6vGVK1BQ8Zw+AH3_zSCsCLVfNENb-Qwn45tb+zwC9Mheg@mail.gmail.com>
References: <1352932107-14782-1-git-send-email-grant.likely@secretlab.ca>
	<20121114.173304.405703188822325414.davem@davemloft.net>
	<CACxGe6vGVK1BQ8Zw+AH3_zSCsCLVfNENb-Qwn45tb+zwC9Mheg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Nov 2012 22:42:26 +0000

> On Wed, Nov 14, 2012 at 10:33 PM, David Miller <davem@davemloft.net> wrote:
>>
>> You're making other changes here, such as the kstrdup() stuff,
>> seperate that into another patch.
> 
> It's part of the same change. The original code was allocating a
> buffer, saving the pointer in the name field and then modifying it.
> Making the code to a kstrdup() gets rid of modifying the const buffer.

Please mention that in your commit message then, thanks.
