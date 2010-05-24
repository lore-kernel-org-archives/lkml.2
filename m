Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0EXWC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:02:26 -0400
Received: from kroah.org ([198.145.64.141]:46907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0EXWCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:02:25 -0400
Date: Mon, 24 May 2010 14:45:14 -0700
From: Greg KH <greg@kroah.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: stable <stable@kernel.org>, linux-nilfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [stable]  nilfs2: fix sync silent failure
Message-ID: <20100524214514.GI16655@kroah.com>
References: <20100519.012423.218986668.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519.012423.218986668.ryusuke@osrg.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:24:23AM +0900, Ryusuke Konishi wrote:
> Please consider commit 973bec34bfc1bc2465646181653d67f767d418c8 for
> inclusion in 2.6.33.y and 2.6.32.y.

All queued up for both trees now, thanks.

greg k-h
