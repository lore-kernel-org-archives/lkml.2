Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab2LNXdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:33:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53959 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab2LNXdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:33:37 -0500
Message-ID: <50CBB775.2000600@ti.com>
Date: Sat, 15 Dec 2012 00:34:13 +0100
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sivaram Nair <sivaramn@nvidia.com>
CC: <ccross@android.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        <rjw@sisk.pl>, <daniel.lezcano@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] cpuidle: coupled: fix ready counter decrement
References: <1355474528-13094-1-git-send-email-sivaramn@nvidia.com>
In-Reply-To: <1355474528-13094-1-git-send-email-sivaramn@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2012 09:42 AM, Sivaram Nair wrote:
> The ready_waiting_counts atomic variable is compared against the wrong
> online cpu count. The latter is computed incorrectly using logical-OR
> instead of bit-OR. This patch fixes that.
>
> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
> ---
Looks right.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

