Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2AQSfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:35:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54394 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2AQSfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:35:51 -0500
Date: Tue, 17 Jan 2012 10:35:46 -0800
From: Tejun Heo <tj@kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: cfq crashing on boot with CONFIG_DEBUG_PAGE_ALLOC (linus
 master)
Message-ID: <20120117183546.GA26207@google.com>
References: <20120117161024.GC30322@shiny>
 <20120117173500.GA6762@google.com>
 <20120117175910.GA3658@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117175910.GA3658@shiny>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oooh, I can reproduce it.  I'll write when I know more.

Thanks.

-- 
tejun
