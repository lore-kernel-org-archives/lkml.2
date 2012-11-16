Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2KPSUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:20:44 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37439 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab2KPSUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:20:43 -0500
Message-ID: <1353089995.10872.80.camel@cumari.coelho.fi>
Subject: Re: [PATCH 108/193] drivers/net/wireless/ti/wl1251: remove
 CONFIG_EXPERIMENTAL
From: Luciano Coelho <coelho@ti.com>
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 16 Nov 2012 20:19:55 +0200
In-Reply-To: <1351022666-6960-109-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-109-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 13:03 -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Luciano Coelho <coelho@ti.com>
> CC: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Applied and pushed to the wl12xx.git tree, thanks!

--
Luca.

