Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965216Ab2J3SI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:08:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45961 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965186Ab2J3SI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:08:27 -0400
Message-ID: <50901798.1050507@wwwdotorg.org>
Date: Tue, 30 Oct 2012 12:08:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3] spi: tegra: add spi driver for SLINK controller
References: <1351580645-17260-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1351580645-17260-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 01:04 AM, Laxman Dewangan wrote:
> Tegra20/Tegra30 supports the spi interface through its SLINK
> controller. Add spi driver for SLINK controller.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
