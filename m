Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2BTMEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 07:04:24 -0500
Received: from tservice.ru ([195.178.208.66]:51144 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751064Ab2BTMEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 07:04:23 -0500
Date: Mon, 20 Feb 2012 15:04:17 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: NeilBrown <neilb@suse.de>
Cc: GregKH <greg@kroah.com>, Thomas Weber <weber@corscience.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Small fixes for w1_bq27000 driver
Message-ID: <20120220120417.GA16526@ioremap.net>
References: <20120219020910.4958.46866.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120219020910.4958.46866.stgit@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil

On Sun, Feb 19, 2012 at 01:10:00PM +1100, NeilBrown (neilb@suse.de) wrote:
> The following three patches fix a problem with the w1 interface for
> the bq27000 battery charge meter, and remove some unnecessary code.

Whole patchset looks very good, thank you
Greg, please pull it into your tree

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
