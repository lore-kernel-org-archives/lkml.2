Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2KZXRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:17:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48639 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab2KZXR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:17:29 -0500
Message-ID: <50B3F886.3090701@wwwdotorg.org>
Date: Mon, 26 Nov 2012 16:17:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ARM: dt: tegra: cardhu: Add drm components
References: <1353396472-24167-1-git-send-email-markz@nvidia.com>
In-Reply-To: <1353396472-24167-1-git-send-email-markz@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 12:27 AM, Mark Zhang wrote:
> This patch adds the rgb node which is needed by
> tegra drm driver.

This doesn't seem to include all the GPIOs/regulators/... required to
enable the panel and backlight.
