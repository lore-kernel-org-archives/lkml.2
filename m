Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab0G3CU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 22:20:59 -0400
Received: from thunk.org ([69.25.196.29]:42379 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab0G3CU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 22:20:58 -0400
Date: Thu, 29 Jul 2010 22:20:55 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Cc: linux <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and
 later
Message-ID: <20100730022055.GL4506@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>,
	linux <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
References: <4C508A54.7070002@uni-konstanz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C508A54.7070002@uni-konstanz.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 09:51:48PM +0200, Kay Diederichs wrote:
> 
> When looking at the I/O statistics while the benchmark is running, we
> see very choppy patterns for 2.6.32, but quite smooth stats for
> 2.6.27-stable.

Could you try to do two things for me?  Using (preferably from a
recent e2fsprogs, such as 1.41.11 or 12) run filefrag -v on the files
created from your 2.6.27 run and your 2.6.32 run?

Secondly can capture blktrace results from 2.6.27 and 2.6.32?  That
would be very helpful to understand what might be going on.

Either would be helpful; both would be greatly appreciated.

Thanks,

						- Ted
