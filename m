Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab2CNH6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:58:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54345
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759256Ab2CNH6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:58:52 -0400
Date: Wed, 14 Mar 2012 03:58:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@akkadia.org>
Cc: arnd@arndb.de, davem@davemloft.net, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: Re: [PATCH] Install kernel-page-flags.h
Message-ID: <20120314075842.GA337@infradead.org>
References: <201203140726.q2E7Q73i021607@drepperk.user.openhosting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203140726.q2E7Q73i021607@drepperk.user.openhosting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 03:26:07AM -0400, Ulrich Drepper wrote:
> Programs using /proc/kpageflags need to know about the various flags.  The
> <linux/kernel-page-flags.h> provides them and the comments in the file
> indicate that it is supposed to be used by user-level code.  But the file
> is not installed.
> 
> The patch below installs the headers and marks the unstable flags as
> out-of-bounds.

I don't think this is a good idea at all.  Let's shoot the person who
added that braindead interface ASAP, and replace it with one printing
the flags in ASCII format. 

