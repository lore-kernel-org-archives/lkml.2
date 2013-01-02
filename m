Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3ABJiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 04:38:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17379 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3ABJiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 04:38:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 02 Jan 2013 01:36:10 -0800
Message-ID: <50E40157.9070902@nvidia.com>
Date: Wed, 2 Jan 2013 11:43:51 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 3/8] gpu: host1x: Add channel support
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <1356089964-5265-4-git-send-email-tbergstrom@nvidia.com> <50E3E45A.5050003@gmail.com> <50E3FE8C.8000309@nvidia.com> <50E3FE57.5070702@gmail.com>
In-Reply-To: <50E3FE57.5070702@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.01.2013 11:31, Mark Zhang wrote:
> On 01/02/2013 05:31 PM, Terje Bergström wrote:
>> That's intentional. Writing a job to channel is atomic, so lock is taken
>> from host1x_cdma_begin() until host1x_cdma_end().
>>
> 
> Okay. So can we consider that lock and unlock this mutex in the function
> which calls host1x_cdma_begin and host1x_cdma_end, that means, in
> current implementation, function "channel_submit"?

Yes, exactly.

Terje

