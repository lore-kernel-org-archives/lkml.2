Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2LQN4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:56:45 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3172 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2LQN4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:56:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 17 Dec 2012 05:56:35 -0800
Message-ID: <50CF25A5.2050803@nvidia.com>
Date: Mon, 17 Dec 2012 16:01:09 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/7] gpu: host1x: Add debug support
References: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>  <1355407484-28904-5-git-send-email-tbergstrom@nvidia.com> <1355412191.12036.2.camel@joe-AO722>
In-Reply-To: <1355412191.12036.2.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2012 17:23, Joe Perches wrote:
> On Thu, 2012-12-13 at 16:04 +0200, Terje Bergstrom wrote:
>> Add support for host1x debugging. Adds debugfs entries, and dumps
>> channel state to UART in case of stuck job.
> 
> trivial note:
> 
> []
> 
>> diff --git a/drivers/gpu/host1x/debug.h b/drivers/gpu/host1x/debug.h
> []
>> +void host1x_debug_output(struct output *o, const char *fmt, ...);
> 
> This should be marked __printf(2, 3)
> so the compiler verifies format and argument types.

Thanks, I didn't know of this "trick". I'll apply it in the next version.

Considering the amount of feedback I've received from the patches, they
must be top notch quality!

Terje

