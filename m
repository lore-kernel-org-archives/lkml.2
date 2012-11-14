Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab2KNUyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:54:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53091 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2KNUyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:54:36 -0500
Message-ID: <50A40509.5080006@wwwdotorg.org>
Date: Wed, 14 Nov 2012 13:54:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Implement 6395/1 for Tegra
References: <1352903243-5389-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1352903243-5389-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 07:27 AM, Peter De Schrijver wrote:
> This patch implements ARM linux patch 6395/1 for Tegra. See commit
> 1a8e41cd672f894bbd74874eac601e6cedf838fb for details.

I've applied this patch to Tegra's for-3.8/soc branch with the following
enhanced commit description:

>     ARM: tegra: Implement 6395/1 for Tegra
>     
>     This patch implements ARM linux patch 6395/1 for Tegra. See commit
>     1a8e41c "ARM: 6395/1: VExpress: Set bit 22 in the PL310 (cache
>     controller) AuxCtlr register" for details.
>     
>     Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
>     [swarren: added commit subject for referenced patch]
>     Signed-off-by: Stephen Warren <swarren@nvidia.com>

