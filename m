Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0HBG55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:57:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37938 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0HBG54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:57:56 -0400
Date: Sun, 1 Aug 2010 23:57:46 -0700
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ftp.linux.org.uk>, Tim Gardner <timg@canonical.com>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100802065746.GS3948@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
 <20100802063224.GR3948@outflux.net>
 <alpine.LRH.2.00.1008021639230.32603@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1008021639230.32603@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 04:41:08PM +1000, James Morris wrote:
> On Sun, 1 Aug 2010, Kees Cook wrote:
> > Well, at least I'll have something for my summit presentation again.
> > 
> > On the other hand, it's rather hard for me to defend against a private NAK.
> 
> It's the same nak as before -- I concluded there was consensus on the 
> lists, but was wrong.
> 
> > James, will it stay in security-testing for .37 hopefully?
> 
> Not with this approach, I'd imagine.

I'm sorry to appear dense, but the most recent NAK from Christoph was
here[1], which was for a patch to Yama that is not in security-testing
yet. Prior to that, all I could find was this[2] which explicitly asked
me to put stuff in a special LSM.

I really would like to see it in mainline, but next steps are not clear.

-Kees

[1] http://lkml.org/lkml/2010/6/30/31
[2] http://lkml.org/lkml/2010/6/1/78

-- 
Kees Cook
Ubuntu Security Team
