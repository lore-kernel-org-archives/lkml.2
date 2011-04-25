Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab1DYOb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:31:26 -0400
Received: from mout.perfora.net ([74.208.4.194]:59367 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab1DYObZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:31:25 -0400
Date: Mon, 25 Apr 2011 10:31:01 -0400
From: Stephen Wilson <wilsons@start.ca>
To: bookjovi@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] proc: put check_mem_permission before __get_free_page
	in mem_read
Message-ID: <20110425143101.GA8222@fibrous.localdomain>
References: <1303086002-6961-1-git-send-email-bookjovi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303086002-6961-1-git-send-email-bookjovi@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:q8Lj1PBg5AvYClCTF5wCCouqBJFYGWmh57bK0odRte2
 VLP6/gI42tmn/Qx0UNNihrurbnMZH4JjnC7UDjx2fPIY+JhtqV
 mZA8PTPCpkgEmAT1gufimmRCiVXZIH/sTrLpwai5YAZzdW7fz3
 wgL2QQDcE4vj9RPh0zWR0tgaitBg2MY07FOodcC1Ln9B4NYmWW
 ncjyZrDPcdtOrEY28zdK9vfa9j9H0255UBz8IJUwQc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 08:20:01PM -0400, bookjovi@gmail.com wrote:
> From: Jovi Zhang <bookjovi@gmail.com>
> 
> It should be better if put check_mem_permission before __get_free_page
> in mem_read, to be same as function mem_write.
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

looks good.

	Reviewed-by: Stephen Wilson <wilsons@start.ca>

-- 
steve

