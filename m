Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0KHQy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:54:28 -0500
Received: from thunk.org ([69.25.196.29]:59796 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab0KHQyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:54:25 -0500
Date: Mon, 8 Nov 2010 11:54:20 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH -v4] ext4: handle writeback of inodes which are being
 freed
Message-ID: <20101108165420.GE3099@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <20101102202013.GA3861@elliptictech.com>
 <20101103181412.GH25614@thunk.org>
 <20101103182229.GA8766@elliptictech.com>
 <20101103205306.GA3627@elliptictech.com>
 <20101107212143.GA28396@thunk.org>
 <20101108011919.GN13830@dastard>
 <20101108050052.GA3099@thunk.org>
 <20101108060535.GB3099@thunk.org>
 <20101108162832.GA22401@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108162832.GA22401@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 11:28:32AM -0500, Nick Bowler wrote:
> 
> After several successful 'make install' tests with this patch:
> 
> Tested-by: Nick Bowler <nbowler@elliptictech.com>
> 
> Thanks.

Thank you for reporting the bug and testing the patches!!

      	      		    	- Ted
