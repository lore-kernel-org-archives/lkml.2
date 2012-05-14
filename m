Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2ENQ0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:26:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44506 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab2ENQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:26:13 -0400
Message-ID: <4FB13221.3000704@wwwdotorg.org>
Date: Mon, 14 May 2012 10:26:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Fix flow controller accesses
References: <1336991229-18859-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1336991229-18859-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 04:27 AM, Peter De Schrijver wrote:
> flowctrl_write_cpu_csr uses the cpu halt offsets and vice versa. This patch
> fixes this bug.
> 
> Reported-by: Dan Willemsen <dwillemsen@nvidia.com>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Applied, thanks.

I fixed the patch description to mention when this problem was introduced.

I'll send a pull request to include this in 3.4-final in a second.
