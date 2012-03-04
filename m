Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2CDSi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:38:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49008 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2CDSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:38:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.68.218.130 as permitted sender) smtp.mail=olof@lixom.net
Date: Sun, 4 Mar 2012 10:38:23 -0800
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 6/6] ARM: tegra: export usb phy symbols
Message-ID: <20120304183823.GD31064@quad.lixom.net>
References: <1330721922-8861-1-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330721922-8861-1-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:58:42PM -0500, Alan Ott wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ehci driver can be a module, so the functions provided
> by the tegra platform code used by ehci-tegra need to
> be exported.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alan Ott <alan@signal11.us>

Thanks, applied.


-Olof
