Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab2IDT2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:28:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38713 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757708Ab2IDT2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:28:44 -0400
X-Sasl-enc: MmrcQcisKxZN7lIkU7RQXEv0ZptaeZKM0d65AlnE7jJg 1346786923
Date: Tue, 4 Sep 2012 12:26:14 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/rts_pstor: Use pr_ printks in debug.h
Message-ID: <20120904192614.GB13081@kroah.com>
References: <1346203766-5939-1-git-send-email-yamanetoshi@gmail.com>
 <1346203816-5975-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346203816-5975-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:30:15AM +0900, Toshiaki Yamane wrote:
> fixed below checkpatch warnings.
> -WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...

No, please use dev_dbg() instead.

thanks,

greg k-h
