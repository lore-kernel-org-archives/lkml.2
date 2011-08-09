Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab1HITag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:30:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54510 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1HITae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:30:34 -0400
Date: Tue, 9 Aug 2011 12:30:52 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Tegra: Force PORT_TEGRA as the UART type
Message-ID: <20110809193052.GA4145@quad.lixom.net>
References: <1312837265-11984-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312837265-11984-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 03:01:05PM -0600, Stephen Warren wrote:
> 8250.c recently gained an explicit PORT_TEGRA port type. Specifically
> request this in all Tegra boards' UART platform data.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks, applied to boards-for-3.2.


-Olof
