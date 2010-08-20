Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab0HTMMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:12:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56304 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HTMMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:12:42 -0400
Date: Fri, 20 Aug 2010 13:12:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Bernd Petrovitsch <bernd@sysprog.at>, Namhyung Kim <namhyung@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce ptr_diff()
Message-ID: <20100820121239.GT31363@ZenIV.linux.org.uk>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
 <87aaoiu6z6.fsf@basil.nowhere.org>
 <1282222109.10440.50.camel@thorin>
 <20100819125957.GB6729@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819125957.GB6729@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 02:59:57PM +0200, Andi Kleen wrote:
> > If so, the warning seems valid as sizeof(struct page) is probably not
> > (always) a power of 2. On a native build on x86_64 it is 56 bytes
> > hereover.
> > Hmm ....
> 
> 
> gcc just generats a mull with inverted value. mull is cheap on any
> reasonable CPU.

Depends on gcc version.

> Please fix sparse.

Frankly, I'd rather stop crapping -Wall into its arguments; there's
a reason why that check is optional and it's *not* defaulting to
on in sparse.
