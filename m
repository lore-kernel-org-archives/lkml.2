Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2FDSGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:06:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38867 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2FDSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:06:39 -0400
Message-ID: <4FCCF92A.9040407@wwwdotorg.org>
Date: Mon, 04 Jun 2012 12:06:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: swarren@nvidia.com, olof@lixom.net, linux@arm.linux.org.uk,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/2] ARM: tegra: config: enable TPS65910 drivers
References: <1337753574-32699-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1337753574-32699-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 12:12 AM, Laxman Dewangan wrote:
> Enable TPS65910 mfd, gpio and regulator drivers.
> This is the PMIC module for Tegra30 based cardhu
> platform.

I've applied just this one patch for 3.6.

