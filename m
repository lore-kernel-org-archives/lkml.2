Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab0DBGlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:41:02 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43461 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392Ab0DBGkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:40:55 -0400
Date: Fri, 2 Apr 2010 08:40:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Block: Fix block/elevator.c elevator_get() off-by-one
	error
Message-ID: <20100402064053.GU23510@kernel.dk>
References: <20100330092132.GB2713@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330092132.GB2713@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30 2010, wzt.wzt@gmail.com wrote:
> elevator_get() not check the name length, if the name length > sizeof(elv),
> elv will miss the '\0'. And elv buffer will be replace "-iosched" as something
> like aaaaaaaaa, then call request_module() can load an not trust module.

Thanks, good catch! Applied.


-- 
Jens Axboe

