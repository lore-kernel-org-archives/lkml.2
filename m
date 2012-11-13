Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2KMSsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:48:18 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58031 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821Ab2KMSsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:48:16 -0500
X-Sasl-enc: +32Z3Jgl8h0uQSjBtmZSxxF/wUgDPHfchODS+Jy2Vuy5 1352832495
Date: Tue, 13 Nov 2012 10:48:14 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20121113184814.GA24793@kroah.com>
References: <20121113165106.e592e23693663de49e9d78d0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113165106.e592e23693663de49e9d78d0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 04:51:06PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> In file included from drivers/power/lp8788-charger.c:15:0:
> include/linux/iio/consumer.h:76:21: error: unknown type name 'u8'
> include/linux/iio/consumer.h:78:11: error: expected ';', ',' or ')' before 'void'
> 
> Caused by commit 92d1079b281f ("staging:iio: add a callback buffer for in
> kernel push interface").  Presumably just a missing include.
> 
> I have reverted that commit for today (it introduces a set of not yet
> used interfaces).

I've fixed this up in the tree now so you shouldn't have this problem
with your next pull.

thanks,

greg k-h
