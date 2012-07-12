Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab2GLMA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:00:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5207 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692Ab2GLMA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:00:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 12 Jul 2012 05:00:25 -0700
Message-ID: <4FFEBAC0.4040606@nvidia.com>
Date: Thu, 12 Jul 2012 17:23:36 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/5] i2c: tegra: convert normal suspend/resume to *_noirq
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com> <1341919244-23327-6-git-send-email-ldewangan@nvidia.com> <20120712103509.GF27520@pengutronix.de> <4FFEA748.9080109@nvidia.com> <20120712115725.GA3772@pengutronix.de>
In-Reply-To: <20120712115725.GA3772@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2012 05:28 PM, Wolfram Sang wrote:
> * PGP Signed by an unknown key
>
>
>> Can you please point me your git path so that I can verify it?
> git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-next
>
> or
>
> http://git.pengutronix.de/?p=wsa/linux.git;a=shortlog;h=refs/heads/i2c-embedded/for-next
>

The change is fine.  No issue here.

Thanks,
Laxman

