Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab2DZRkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:40:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1643 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2DZRkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:40:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Apr 2012 10:40:53 -0700
Message-ID: <4F998843.9080108@nvidia.com>
Date: Thu, 26 Apr 2012 23:09:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 3/4] ARM: dt: tegra: enable als and proximity sensor
References: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com> <1335183097-21104-5-git-send-email-ldewangan@nvidia.com> <4F958E42.6030506@wwwdotorg.org>
In-Reply-To: <4F958E42.6030506@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2012 10:45 PM, Stephen Warren wrote:
> On 04/23/2012 06:11 AM, Laxman Dewangan wrote:
>> Add the device info for ALS and proximity sensor for tegra
>> boards cardhu, ventana and seabridge.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Thanks, applied.
>
> I made the following minor changes: s/PZ02/PZ2/ in .dts files,
> s/seabridge/seaboard/ in commit description
>
> I note that the proximity detection doesn't appear to work on my Cardhu,
> although the light sensor works. Is that expected? Both work on Seaboard
> and Ventana.

Yes, there is problem in cardhu about component mounting for ir led. 
This is fixed on other version of reference  board.
So on cardhu, proximity sensing always return 0xFF.

