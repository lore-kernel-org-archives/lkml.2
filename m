Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0HSNj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:39:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59318 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0HSNj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:39:27 -0400
Date: Thu, 19 Aug 2010 15:39:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce ptr_diff()
Message-ID: <20100819133922.GC6729@basil.fritz.box>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
 <87aaoiu6z6.fsf@basil.nowhere.org>
 <1282222109.10440.50.camel@thorin>
 <20100819125957.GB6729@basil.fritz.box>
 <1282223113.10440.78.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282223113.10440.78.camel@thorin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 03:05:13PM +0200, Bernd Petrovitsch wrote:
> On Don, 2010-08-19 at 14:59 +0200, Andi Kleen wrote:
> > > If so, the warning seems valid as sizeof(struct page) is probably not
> > > (always) a power of 2. On a native build on x86_64 it is 56 bytes
> > > hereover.
> > > Hmm ....
> > 
> > gcc just generats a mull with inverted value. mull is cheap on any
> > reasonable CPU.  Please fix sparse.
> 
> Not that I really know the code of sparse but what would be an
> acceptable condition (except plain simply disabling/removing the warning
> as such)?

I think acceptable would be to warn if the type is variable sized
(although I think gcc likely would error out in this case anyways)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
