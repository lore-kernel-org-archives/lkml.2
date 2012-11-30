Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769287Ab2K3T25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:28:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38765 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992619Ab2K3T2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:28:54 -0500
Message-ID: <50B908F1.8000407@wwwdotorg.org>
Date: Fri, 30 Nov 2012 12:28:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: thierry.reding@avionic-design.de, linux@arm.linux.org.uk,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dt: tegra: cardhu: Add drm components
References: <1354254256-10212-1-git-send-email-markz@nvidia.com>
In-Reply-To: <1354254256-10212-1-git-send-email-markz@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 10:44 PM, Mark Zhang wrote:
> This patch adds the RGB & HDMI nodes in Tegra 30 cardhu's dts.
> This makes the LVDS & HDMI working.

This still doesn't add any of the backlight/panel GPIO programming,
which I believe is required before we enable any LCDs. We could add the
HDMI node without that though.
