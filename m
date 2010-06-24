Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0FXTAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:00:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56536 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0FXTAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:00:18 -0400
Date: Thu, 24 Jun 2010 14:53:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Larry.Finger@lwfinger.net, mb@bu3sch.de, zajec5@gmail.com
Subject: Re: [PATCH 0/3] b43: logging cleanups
Message-ID: <20100624185339.GC2368@tuxdriver.com>
References: <cover.1276988387.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1276988387.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 04:30:08PM -0700, Joe Perches wrote:
> Just some small cleanups
> 
> Joe Perches (3):
>   drivers/net/wireless/b43: Use local ratelimit_state
>   drivers/net/wireless/b43: Logging cleanups
>   drivers/net/wireless/b43: Rename b43_debug to b43_debugging

Any of the b43 guys want to express an opinion on these?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
