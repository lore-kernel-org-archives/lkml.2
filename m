Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab2BNRPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:15:22 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46215 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758281Ab2BNRPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:15:21 -0500
X-Sasl-enc: dqkc+QVqrkUlxAEA0ZyFruNSn0GKTQzp3tNK9fcqQT88 1329239720
Date: Tue, 14 Feb 2012 09:14:34 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: Remove CPP abuse
Message-ID: <20120214171434.GA1698@kroah.com>
References: <1329237367.2293.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329237367.2293.17.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 05:36:07PM +0100, Peter Zijlstra wrote:
> There's absolutely no reason to abuse CPP to shorten a common sub
> expression, C has variables for this.
> 
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  fs/sysfs/dir.c |    6 ++++--

This is all fixed up already in linux-next, thanks though.

greg k-h
