Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab2EWKhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:37:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21259 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2EWKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:37:45 -0400
Date: Wed, 23 May 2012 13:41:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Staging: ipack: fix failure registering an ipack
 device
Message-ID: <20120523104115.GL4637@mwanda>
References: <1337764395-23200-1-git-send-email-siglesias@igalia.com>
 <1337764395-23200-2-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337764395-23200-2-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:13:14AM +0200, Samuel Iglesias Gonsalvez wrote:
> Trying to install an ipack device it always failed in the match() function. This
> patch fixes all the bugs present there.
> 

This looks like part of it is undoing stuff introduced in
[patch 1/3]?  I was going to ask what the stuff was in 1/3 and then
it got removed which makes me wonder why even more.  Could you write
something about why in your changelog?  Or if it's not needed then
remove it from the first patch.

Really it would be easier to review if you broke it up into one
patch per bug, with a description of what the bugs were instead of
"patch fixes all the bugs present there".

Some of these changes don't seem necessary.  It feels like you were
debugging and then when you got match() to work you just committed
all the changes instead of only the lines which are needed.

regards,
dan carpenter
