Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab2HUWGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:06:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42928 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab2HUWGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:06:18 -0400
Date: Tue, 21 Aug 2012 23:06:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jim Rees <rees@umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120821220613.GK23464@ZenIV.linux.org.uk>
References: <20120821212910.GD18637@fieldses.org>
 <20120821212227.GA14194@umich.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821212227.GA14194@umich.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:22:27PM -0400, Jim Rees wrote:
> J. Bruce Fields wrote:
> 
>   From: "J. Bruce Fields" <bfields@redhat.com>
>   
>   I've seen a couple examples recently where we've gotten this wrong.
>   Maybe something like this would help?  Is there some better way?
>   
>   (Approximation due to Jim Rees).
> 
> Please add Suggested-by: Jim Rees <rees@umich.edu>.  I'm thinking of
> patenting the algorithm.

Is that a joke?  Patenting the fact that log10(256) is 2.408..., which
is about 2.4, which is 24/10?  I really hope we are Poe'd...  BTW, NAK
the comment - s/36/26/ in there; check it yourself -
$ echo '2^(8*27)' | bc
105312291668557186697918027683670432318895095400549111254310977536
which is 66-digit, not 65 as the estimate would be.
