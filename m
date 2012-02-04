Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2BDNdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 08:33:36 -0500
Received: from bar.sig21.net ([80.81.252.164]:51560 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2BDNdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 08:33:35 -0500
Date: Sat, 4 Feb 2012 14:33:31 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: swap storm since kernel 3.2.x
Message-ID: <20120204133331.GA13223@sig21.net>
References: <201202041109.53003.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201202041109.53003.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 11:09:52AM +0100, Toralf Förster wrote:
> Within the last few weeks I'm observing sometimes a swap storm at my ThinkPad 
> while compiling/installing new packages at my Gentoo Linux - the load is often 
> something like :
> 
> Load avg: 13.6, 20.6, 20.9
> 
> I'm wondering whether this is related to kernel 3.2.x /Gentoo specific or 
> related to my system only.

Do you happen to have CONFIG_DEBUG_OBJECTS enabled?  For me it
ate lots of memory with 3.2.2, easily visible in slabtop.


Johannes
