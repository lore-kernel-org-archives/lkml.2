Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab2EJEqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 00:46:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2273 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2EJEqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 00:46:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 May 2012 21:45:25 -0700
Message-ID: <4FAB4736.8070301@nvidia.com>
Date: Thu, 10 May 2012 10:12:30 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the regmap
 tree
References: <20120510142552.35f8e15042053707a2086905@canb.auug.org.au>
In-Reply-To: <20120510142552.35f8e15042053707a2086905@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012 09:55 AM, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>
> Hi all,
>
> Today's linux-next merge of the sound-asoc tree got a conflict in
> drivers/base/regmap/regmap.c between commit 6560ffd1ccd6 ("regmap: fix
> possible memory corruption in regmap_bulk_read()") from the regmap tree
> and commit edc9ae420f98 ("regmap: implement register striding") from the
> sound-asoc tree.
>
> I fixed it up (see below) and can carry the fix as necessary.
The change looks fine to me.

