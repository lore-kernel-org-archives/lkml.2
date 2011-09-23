Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab1IWRiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:38:11 -0400
Received: from peace.netnation.com ([204.174.223.2]:59914 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1IWRiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:38:09 -0400
Date: Fri, 23 Sep 2011 10:38:08 -0700
From: Simon Kirby <sim@hostway.ca>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [3.1-rc6] kmalloc(64) leak from IDE
Message-ID: <20110923173808.GB26481@hostway.ca>
References: <20110922072643.GA27232@hostway.ca> <20110922084811.GC17640@liondog.tnic> <20110922202337.GB32661@hostway.ca> <20110923072118.GA13293@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110923072118.GA13293@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 09:21:18AM +0200, Borislav Petkov wrote:

> On Thu, Sep 22, 2011 at 01:23:37PM -0700, Simon Kirby wrote:
> > Yes, that seems to have made it stop complaining about the IDE path.
> 
> Good, thanks for testing. It would be great if you left it running for
> a couple of days like this to see whether there aren't any other issues
> with the patch. I'll send it with a proper description to Dave soonish
> since this is a real bug.

It has been up 22 hours now without breaking. I suppose you're worried
about the old command being used after it gets reused. Would it help to
bisect the regression to see how it used to work? That would let us know
how many stable kernels to patch, too.

Simon-
