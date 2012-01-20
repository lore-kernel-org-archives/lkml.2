Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2ATML5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 07:11:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53783 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442Ab2ATMLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:11:54 -0500
Date: Fri, 20 Jan 2012 12:11:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regulator: tps65910: use appropriate variable names.
Message-ID: <20120120121152.GC18297@opensource.wolfsonmicro.com>
References: <1327057582-6635-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327057582-6635-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:36:22PM +0530, Laxman Dewangan wrote:
> Renaming the variables "table" to "voltage_table" and
> "table_len" to "n_voltages" of regulator information
> to have more meaningful.

Applied, thanks.
