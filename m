Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab0FVRYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:24:18 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56025 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866Ab0FVRYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:24:15 -0400
Message-ID: <4C20F1C2.5020009@kernel.dk>
Date: Tue, 22 Jun 2010 19:24:18 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] block/xd.c: fix brace typo
References: <20100622160518.2ef7afcc.sfr@canb.auug.org.au> <20100622090343.d921a70c.randy.dunlap@oracle.com>
In-Reply-To: <20100622090343.d921a70c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-22 18:03, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix extra brace typo that is causing build errors

Thanks Randy, applied.

-- 
Jens Axboe

