Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2KPSX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:23:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37590 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab2KPSX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:23:57 -0500
Message-ID: <1353090198.10872.82.camel@cumari.coelho.fi>
Subject: Re: [PATCH 4/7] wlcore: Fix the usage of wait_for_completion_timeout
From: Luciano Coelho <coelho@ti.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: <eliad@wizery.com>, <linux-kernel@vger.kernel.org>
Date: Fri, 16 Nov 2012 20:23:18 +0200
In-Reply-To: <1352222894.15558.1595.camel@cliu38-desktop-build>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
	 <1352222480.15558.1587.camel@cliu38-desktop-build>
	 <1352222555.15558.1589.camel@cliu38-desktop-build>
	 <1352222894.15558.1595.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 01:28 +0800, Chuansheng Liu wrote:
> The return value of wait_for_completion_timeout() is always
> >= 0 with unsigned int type.
> 
> So the condition "ret < 0" or "ret >= 0" is pointless.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---

Applied and pushed via wl12xx.git.

Thank you!

--
Luca.

