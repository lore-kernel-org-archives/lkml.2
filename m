Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1AMEMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 23:12:14 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38938 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab1AMEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 23:12:11 -0500
Date: Thu, 13 Jan 2011 13:10:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: move SH_MIPI_DSI/SH_LCD_MIPI_DSI to the top of menu
Message-ID: <20110113041002.GC12013@linux-sh.org>
References: <1294845575-4508-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294845575-4508-1-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 06:19:35PM +0300, Dmitry Eremin-Solenikov wrote:
> Kconfig entries SH_MIPI_DSI and SH_LCD_MIPI_DSI while being invisible to
> the user, broke the FrameBuffer menu (at least in menuconfig), as they
> aren't depending on respective menuconfig item (FB). In result several
> items got moved to the main "Graphics support" menu. Move these two
> problematic items to the top of drivers/video/Kbuild to restore nice
> display of FB menu.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Applied, thanks.
