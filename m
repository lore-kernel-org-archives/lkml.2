Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2BCEqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 23:46:46 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1756 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2BCEqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 23:46:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 02 Feb 2012 20:46:24 -0800
Message-ID: <4F2B6654.8060106@nvidia.com>
Date: Fri, 3 Feb 2012 10:15:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: manual merge of the gpio tree with the regulator
 tree
References: <20120203134415.624d07b379876f1e5f0c644a@canb.auug.org.au>
In-Reply-To: <20120203134415.624d07b379876f1e5f0c644a@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 February 2012 08:14 AM, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>
> Hi Grant,
>
> Today's linux-next merge of the gpio tree got a conflict in
> include/linux/mfd/tps65910.h between commit 1e0c66f49762 ("regulator:
> tps65910: Sleep control through external inputs") from the regulator tree
> and commit 290705988073 ("gpio: tps65910: Add sleep control support")
> from the gpio tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
Yes, merge is fine.. Thanks for taking care of conflicts.
