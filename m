Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0FZNrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 09:47:06 -0400
Received: from thunk.org ([69.25.196.29]:59281 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0FZNrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 09:47:04 -0400
Date: Sat, 26 Jun 2010 09:46:38 -0400
From: tytso@mit.edu
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: (stupid) how to specify the root-device via kernel parameters
Message-ID: <20100626134638.GQ6843@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Christoph Anton Mitterer <calestyo@scientia.net>,
	linux-kernel@vger.kernel.org
References: <1277553549.29791.38.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277553549.29791.38.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 01:59:09PM +0200, Christoph Anton Mitterer wrote:
> 
> My question:
> These are intended (especially root/nfsroot) to really name the device,
> on which the filesystem directly lays, right?
> E.g. if the ext4-root-fs is on /dev/sda1,... => root=/dev/sda1
> 
> I've seen several initramfs scripts (which I'd like to fix),... where
> people abuse this or misuse this in setups where a root-fs is used on
> multi-stacked block layers (e.g. something like disk->lvm->dm-crypt->fs)

Abuse this how?  What do you think is "wrong"?

							- Ted
