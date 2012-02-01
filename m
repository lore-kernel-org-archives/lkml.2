Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2BAH1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:27:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48975 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2BAH1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:27:01 -0500
Date: Tue, 31 Jan 2012 23:26:59 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] ARM: tegra: export the chipid
Message-ID: <20120201072659.GD7399@quad.lixom.net>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
 <1328028051-24271-2-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328028051-24271-2-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 06:40:39PM +0200, Peter De Schrijver wrote:
> Export a variable containing the Tegra chipid. This will be used by the SMP
> code to distinguish between Tegra variants. Also initialize the Tegra chipid
> on Tegra30.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Ideally this patch should be split up in a couple of separate ones, first
cleanup, then the new functionality. But it's not a big deal, and I'll apply it
as it is now. Just something to keep in mind for the next time around.


-Olof

