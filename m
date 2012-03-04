Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2CDShf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:37:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57499 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2CDShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:37:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.68.125.133 as permitted sender) smtp.mail=olof@lixom.net
Date: Sun, 4 Mar 2012 10:37:32 -0800
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/6] ARM: tegra: build localtimer support only when
 needed
Message-ID: <20120304183732.GC31064@quad.lixom.net>
References: <1330721912-8694-1-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330721912-8694-1-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:58:32PM -0500, Alan Ott wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> It is possible to build a tegra kernel without localtimer
> support, so the tegra specific parts should only be built
> when that is indeed enabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alan Ott <alan@signal11.us>

Thanks, applied.

-Olof
