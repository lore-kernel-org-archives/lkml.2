Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2CDShP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:37:15 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54125 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2CDShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:37:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.68.234.1 as permitted sender) smtp.mail=olof@lixom.net
Date: Sun, 4 Mar 2012 10:37:10 -0800
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/6] ARM: tegra: select CPU_FREQ_TABLE
Message-ID: <20120304183710.GB31064@quad.lixom.net>
References: <1330721908-8633-1-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330721908-8633-1-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:58:28PM -0500, Alan Ott wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The tegra cpufreq implementation relies on the cpu_freq_table
> code, so make sure that this is always there when needed.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alan Ott <alan@signal11.us>

This didn't apply cleanly to the tegra tree (what was it based on?), but
I fixed it up manually and applied to for-3.4/cleanups-and-fixes.


Thanks,

-Olof
