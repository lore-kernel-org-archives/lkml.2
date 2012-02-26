Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2BZV7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 16:59:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51535 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2BZV7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 16:59:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.68.74.138 as permitted sender) smtp.mail=olof@lixom.net
Date: Sun, 26 Feb 2012 13:59:25 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Add tegra30 support for secondary cores
Message-ID: <20120226215925.GD11189@quad.lixom.net>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 01:47:40AM +0200, Peter De Schrijver wrote:
> This patchset introduces support for secondary cores on tegra30. It also
> introduces some functions for the flowcontroller and adds basic support for
> tegra30 powerdomains.

Thanks, I've applied this series in a new for-3.4/t3-smp branch: It depends and
pulls in both for-3.4/soc and for-3.4/soc-drivers, but I didn't want to just
add it on top of soc-drivers on the same topic.

I added the comment to headsmp.S that Colin had a nit about, besides that it
was just a couple of minor trivial context conflicts that I fixed up.

Please follow up with separate patches for the shutdown issues, etc.


Thanks!


-Olof

