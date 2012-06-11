Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2FKGTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:19:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2FKGTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:19:40 -0400
Date: Mon, 11 Jun 2012 14:19:28 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sameo@linux.intel.com, Richard Zhao <richard.zhao@linaro.org>,
        grandpaul@gmail.com
Subject: Re: [PATCH RESEND] mfd: anatop: permit adata be NULL when access
 register
Message-ID: <20120611061925.GC2552@S2101-09.ap.freescale.net>
References: <1338774989-4416-1-git-send-email-richard.zhao@freescale.com>
 <20120604021315.GB2857@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604021315.GB2857@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:13:16AM +0800, Richard Zhao wrote:
> Cc Paul's other mail address.
> 
> On Mon, Jun 04, 2012 at 09:56:29AM +0800, Richard Zhao wrote:
> > From: Richard Zhao <richard.zhao@linaro.org>
> > 
> > It makes anatop register access easier. Anatop has many misc registers,
> > which may not be a specific driver.
> > 
> > There's only one anatop device for a running system, so we use a global
> > variable to store struct anatop.
> > 
> > Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
> > Cc: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
