Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2CRRgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 13:36:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab2CRRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 13:36:05 -0400
Date: Sun, 18 Mar 2012 10:36:06 -0700
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 4/5] ARM: tegra: select USB_ULPI if USB is selected
Message-ID: <20120318173606.GA24327@quad.lixom.net>
References: <1330727075-10974-1-git-send-email-alan@signal11.us>
 <1330727160-11242-1-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330727160-11242-1-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 05:26:00PM -0500, Alan Ott wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Automatically select USB_ULPI if USB is enabled on Tegra.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alan Ott <alan@signal11.us>

Thanks, applied. I think this was the last outstanding patch that I had not yet
applied. Since there had been some slight confusion with v2 vs v3, please check
the contents of the tegra for-next branch and make sure it contains what you
would expect it to.

Thanks!


-Olof
