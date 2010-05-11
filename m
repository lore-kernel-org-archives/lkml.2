Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317Ab0EKHCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:02:22 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43406 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062Ab0EKHCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:02:20 -0400
Date: Tue, 11 May 2010 09:02:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] paride: fix menu indentation
Message-ID: <20100511070219.GL27497@kernel.dk>
References: <20100507144756.fbebdebe.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507144756.fbebdebe.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07 2010, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make the PARIDE menu be displayed correctly, with proper/expected
> indentation, by moving the GDROM kconfig symbol, which was
> splitting the PARIDE kconfig symbol from its dependent symbols.

Thanks Randy, applied to for-2.6.35.

-- 
Jens Axboe

