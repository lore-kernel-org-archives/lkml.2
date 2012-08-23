Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab2HWPC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:02:59 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17790 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2HWPCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:02:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 23 Aug 2012 08:02:43 -0700
Message-ID: <50364179.6070304@nvidia.com>
Date: Thu, 23 Aug 2012 20:13:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "rabin.vincent@gmail.com" <rabin.vincent@gmail.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: disable supply regulator if it is enabled
 for boot-on
References: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com> <5034AA28.5050306@nvidia.com> <20120823145308.GA28328@sirena.org.uk>
In-Reply-To: <20120823145308.GA28328@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012 08:23 PM, Mark Brown wrote:
> On Wed, Aug 22, 2012 at 03:15:12PM +0530, Laxman Dewangan wrote:
>> Hi Rabin,
>> Is it resolved the issue you mentioned?
> He replied to your mail pointing out that it generated a lockdep issue.
Thanks Mark for letting me know. The mail transfer to some other folder 
of my mail due to some issue in outlook.
Let me create some more scenario to reproduce this.


