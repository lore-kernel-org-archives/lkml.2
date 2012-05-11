Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946098Ab2EKRyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:54:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52828 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945997Ab2EKRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:54:34 -0400
Message-ID: <4FAD5255.1020908@wwwdotorg.org>
Date: Fri, 11 May 2012 11:54:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: gregkh@linuxfoundation.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: tegra20: Make MC optional in Kconfig
References: <20120511095012.57f737d1b0d2536e0d367a9b@nvidia.com> <1336719389-28506-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1336719389-28506-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 12:56 AM, Hiroshi DOYU wrote:
> For bare minimal system.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>

Patches 1 and 2,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

I'll take patch 3 through the Tegra tree along with the .dts changes.
