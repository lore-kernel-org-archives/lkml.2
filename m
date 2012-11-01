Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578Ab2KAOTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:19:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34123 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761544Ab2KAOTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:19:41 -0400
Date: Thu, 1 Nov 2012 15:23:38 +0100
From: Dave Martin <dave.martin@linaro.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Tekkaman Ninja <tekkamanninja@gmail.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH]Documentation: Chinese translation of
 Documentation/arm/kernel_user_helpers.txt
Message-ID: <20121101142338.GA29971@linaro.org>
References: <20121030162004.GA3467@Super-MAGI>
 <20121030190349.GC5044@thunk.org>
 <20121031110619.GC3780@linaro.org>
 <20121031213415.GB17305@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031213415.GB17305@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:34:15PM -0400, Theodore Ts'o wrote:
> On Wed, Oct 31, 2012 at 12:06:19PM +0100, Dave Martin wrote:
> > 
> > What's the best way of making sure that changes in the source document
> > propagate to translated versions?
> > 
> > It might be enough to put a note in the source document to remind people
> > to check for the extistence of translated versions and CC the relevant
> > translation maintianers with any patches affecting the source document.
> 
> What I was suggesting was even more light-weight.  Just include at the
> very beginning or the very end of the the file the last time the
> translation was updated, and either the kernel version (i..e, v3.6) or
> the git commit ID (i.e., df981d03eeff) that was used for the source
> document.
> 
> That way, someone who reads the file will know how "fresh" the
> document is, and the reader can do a "git log -p
> Documentation/arm/kernel_user_helpers 1234567890abcd.." to see all of
> the changes made to the file since the last time the translation was
> updated.
> 
> People will inevitably remember to forget to notify the translation
> maintainers, and as the number of translations go up, the more
> workload we put on the everyone else.  If we simply mark the
> translation, then the translators can poll to refresh the document at
> their leisure, or perhaps this allows anyone who is using the
> translated documentation file and who has a reasonable command of
> English to do the "git log -p ..." command and perhaps contribute a
> patch to update the translation.  So I think this approach would scale
> much better.

The only potential issue I see here is that the final commit ID may not
be known at least until the patch is applied in a maintainer tree.  But
I guess this is not a different problem from existing practices where a
patch references commit IDs.

It sounds like a reasonable, practical approach to me.

Cheers
---Dave
