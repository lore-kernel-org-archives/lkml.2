Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2BTPWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:22:39 -0500
Received: from tservice.ru ([195.178.208.66]:54464 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752325Ab2BTPWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:22:38 -0500
Date: Mon, 20 Feb 2012 18:22:36 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Thomas Weber <weber@corscience.de>
Cc: NeilBrown <neil.brown@suse.de>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <greg@kroah.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP: hdq: software-supervised control of HDQ_ICLK
Message-ID: <20120220152236.GA32563@ioremap.net>
References: <4F422C2B.9030908@gmail.com>
 <1329746160-1152-1-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329746160-1152-1-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 02:56:00PM +0100, Thomas Weber (weber@corscience.de) wrote:
> the patch below fixes the communication between omap3 and
> bq27000 battery.
> 
> I got the patch from Neil's git tree and removed the part for hdq1w.

Guys, can you submit whole patchset without splitting it into patches,
which eventually may conflict with the same tree sent by someone else?

-- 
	Evgeniy Polyakov
