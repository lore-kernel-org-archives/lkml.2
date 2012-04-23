Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2DWQb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:31:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45587 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2DWQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:31:25 -0400
Message-ID: <4F9583DA.2090107@wwwdotorg.org>
Date: Mon, 23 Apr 2012 10:31:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Initialize pll_p_out1
References: <1335169910-29403-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1335169910-29403-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 02:31 AM, Peter De Schrijver wrote:
> pll_a uses pll_p_out1 as its parent. Therefore this clock needs to be
> initialized to make sure pll_a has a known input clock. Failure to do so
> will cause the system to crash early in the bootup.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Thanks, applied.

> --
> 
> Changes in v2:


BTW, that "--" needs to be "---" if you don't intend the changelog to
end up in git when I apply the patch.
