Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0HPTFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:05:31 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59046 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab0HPTF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:05:29 -0400
Date: Mon, 16 Aug 2010 21:05:27 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dan Carpenter <error27@gmail.com>
Cc: Amit Kumar Salecha <amit.salecha@qlogic.com>,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 16/16] drivers/net/qlcnic: Use available error codes
In-Reply-To: <20100816183540.GE645@bicker>
Message-ID: <Pine.LNX.4.64.1008162105120.12526@ask.diku.dk>
References: <Pine.LNX.4.64.1008161828520.19313@ask.diku.dk> <20100816183540.GE645@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010, Dan Carpenter wrote:

> On Mon, Aug 16, 2010 at 06:29:13PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The error code is stored in the variable err, but it is the variable ret
> > that is returned instead.  So store the error code in ret.  Err is then
> > useless.
> 
> Could you redo this for the latest git?  (Sorry, I recently made the
> problem slightly worse by adding another "err = -ENOMEM;")...

Sure.  I'll send it shortly.

julia
