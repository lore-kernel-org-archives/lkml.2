Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab1FVSjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:39:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758164Ab1FVSjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:39:10 -0400
Date: Wed, 22 Jun 2011 11:38:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, mingo@elte.hu,
        hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-Id: <20110622113851.471f116f.akpm@linux-foundation.org>
In-Reply-To: <20110622182445.GG3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
	<20110622110034.89ee399c.akpm@linux-foundation.org>
	<20110622182445.GG3263@one.firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 20:24:45 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > So.  What are your thoughts on these issues?
> 
> Sounds orthogonal to me. You have to crawl before you walk.
> 
> A better way to pass in the data would be nice, but can be always
> added on top (e.g. some EFI environment variable) 
> 
> For a first try a command line argument is quite
> appropiate and simple enough.
> 
> A check for removing too much memory would be nice though,
> although it's just a choice between panicing early or later.
> 

If something can be grafted on later then that's of course all good.  I
do think we should have some sort of plan in which we work out how that
will be done.  If we want to do it, that is.

However if we go this way then there's a risk that we'll end up with
two different ways of configuring the feature and we'll need to
maintain the old way for ever.  That's a bad thing and we'd be better
off implementing the fancier scheme on day one.
