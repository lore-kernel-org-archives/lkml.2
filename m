Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab2E1L3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:29:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52723 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985Ab2E1L3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:29:12 -0400
X-Sasl-enc: N6A7+FkHAUIRqb9nEdvb3/ZE3NpB43ssw5k2rfylcBw1 1338204551
Date: Mon, 28 May 2012 20:29:06 +0900
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tty changes for the locking warnings.
Message-ID: <20120528112906.GA6188@kroah.com>
References: <20120528094741.3001.29866.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528094741.3001.29866.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 10:48:37AM +0100, Alan Cox wrote:
> Fix the tty locking warnings. This doesn't include the patches to the
> lock markup as I'm not sure which are the final valid ones there.

So this should take care of the issues people have reported?  Or are
Peter's patches still needed?

thanks,

greg k-h
