Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3AGQwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:52:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41461 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3AGQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:52:13 -0500
Message-ID: <50EAFD36.9070909@wwwdotorg.org>
Date: Mon, 07 Jan 2013 09:52:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: dmitry.torokhov@gmail.com, swarren@nvidia.com, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V4 0/4] input: keyboard: tegra: cleanups and DT supports
References: <1357470900-12619-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357470900-12619-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2013 04:14 AM, Laxman Dewangan wrote:
> This patch series:
>  - fix build warning,
>  - use devm_* for allocation,
>  - make column/rows configuration through DT and 
>  - remove the rarely used  key mapping table.

The series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

