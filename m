Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1GFIUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:20:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18555 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1GFIUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:20:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Jul 2011 01:20:02 -0700
Message-ID: <4E141AAF.1060405@nvidia.com>
Date: Wed, 6 Jul 2011 17:19:59 +0900
From: Jinyoung Park <jinyoungp@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ko; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: backlight: aat2870_bl: questions about setting max_current
References: <1309935342.6088.5.camel@phoenix> <4E1411B1.8020102@nvidia.com> <CAF+7xW=M_PBQhyt3H450Lijo8uXyz+r0PQ0LHLqQ15z=6uBz2Q@mail.gmail.com>
In-Reply-To: <CAF+7xW=M_PBQhyt3H450Lijo8uXyz+r0PQ0LHLqQ15z=6uBz2Q@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Axel

 > Yet another question:
 > (Just a quick check at the datasheet.)
 > Why not just set max_current to AAT2870_CURRENT_27_9?
 > Why do you want max_current to be configurable by pdata?
I think that the max backlight current should be configured according to
required power consumption and it could be different for each platform.
So the max_current value be controlled.

Thanks,
Jin.
