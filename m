Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3ABWBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:01:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54494 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3ABWBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:01:00 -0500
Message-ID: <50E4AE19.1060503@wwwdotorg.org>
Date: Wed, 02 Jan 2013 15:00:57 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 05/11] ARM: dt: tegra30: Add device node for APB MISC
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com> <1356619644-18565-6-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1356619644-18565-6-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 07:47 AM, Prashant Gaikwad wrote:
> APB misc contains multiple registers required by different modules
> such as CAR.

I don't see a DT binding document that describes what
nvidia,tegra30-apbmisc means. Also, the register range for this new node
overlaps that for the pinmux node, so they can't both "request" their
register region. You may need multiple entries in the apbmisc reg
property to avoid this.
