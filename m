Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2DWRQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:16:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54281 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2DWRQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:16:22 -0400
Message-ID: <4F958E63.8000200@wwwdotorg.org>
Date: Mon, 23 Apr 2012 11:16:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 4/4] ARM: tegra: defconfig: add ISL29028
References: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com> <1335183097-21104-6-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1335183097-21104-6-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 06:11 AM, Laxman Dewangan wrote:
> The ISL29028 is ALS and proximity sensor and used in
> tegra cardhu.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Thanks, applied.

Note that I squashed it into the existing defconfig update commit to
avoid too many commits touching that file.
