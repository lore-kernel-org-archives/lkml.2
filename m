Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2JOVSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:18:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36943 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2JOVSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:18:42 -0400
Message-ID: <507C7DAF.6020504@wwwdotorg.org>
Date: Mon, 15 Oct 2012 15:18:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: krakesh@nvidia.com, ldewangan@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] ARM: tegra: enable wlan for t20 and t30
References: <1348217700-12309-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1348217700-12309-1-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 02:54 AM, Wei Ni wrote:
> Enable wlan for following tegra board:
> Tegra30: Cardhu.
> Tegra20: Seaboard, Ventana.
> 
> Note that this series depends on specific brcmfmac patches:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/97337.

Now that those patches are in 3.7-rc1, I've applied this series to
Tegra's for-3.8/wifi branch (first 4) and for-3.8/defconfig branch (last
1). I'm not 100% sure yet exactly which patches will appear for 3.8; I
might just make a single for-3.8/dt branch instead of having a separate
wifi branch; we'll see...

Thanks.
