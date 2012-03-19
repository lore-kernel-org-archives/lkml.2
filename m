Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2CSEeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:34:21 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55804 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2CSEeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:34:20 -0400
Date: Mon, 19 Mar 2012 00:34:20 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Message-ID: <20120319043420.GL31682@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, joe@perches.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <cover.1331856299.git.joe@perches.com>
 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
 <20120319040950.GG31682@thunk.org>
 <20120319.001430.1735750114727679638.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319.001430.1735750114727679638.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 12:14:30AM -0400, David Miller wrote:
> 
> I apply patches like Joe's all the time to the networking, consistency
> has high value whether you choose to believe it or not.  And no we
> don't have huge problems with patch conflicts and stuff like that
> either, it simply isn't a real issue so don't use that as an excuse
> either.
> 

It is for me.

Things like printk(KERN_INFO, ...) are quite well established, and
changing really doesn't add any value.  Sorry, I just don't buy the
consistency argument.  I'd much rather keep everything consistent
within ext3 and ext4.

If you want to apply those sorts of patches, feel free.  I choose not
to, and I actively discourage kernel newbies from running
checkpatch.pl --file and trying to fix random things.  (A few years
ago everyone agreed that that was a waste of time.)

						- Ted
