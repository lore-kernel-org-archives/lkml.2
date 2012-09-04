Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab2IDT2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:28:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47097 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757660Ab2IDT23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:28:29 -0400
X-Sasl-enc: j6fVz63Ej5WhnXXsVsP46mNwKMDxuG/H98ofdlGXZFum 1346786908
Date: Tue, 4 Sep 2012 12:25:59 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging/rts_pstor: Use pr_ printks in rtsx.c
Message-ID: <20120904192559.GA13081@kroah.com>
References: <1346203766-5939-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346203766-5939-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:29:26AM +0900, Toshiaki Yamane wrote:
> fixed some checkpatch warnings.
> -WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
> -WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

No, please use dev_info() and dev_err() instead wherever possible.

thanks,

greg k-h
