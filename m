Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab2FRE60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:58:26 -0400
Received: from linux-sh.org ([111.68.239.195]:58412 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2FRE6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:58:25 -0400
Date: Mon, 18 Jun 2012 13:58:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20120618045807.GD19803@linux-sh.org>
References: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au>
 <20120614030606.GC27673@linux-sh.org>
 <20120614034036.GE27673@linux-sh.org>
 <20120615101407.369c754da872e18c854ab481@canb.auug.org.au>
 <20120615005621.GE22007@linux-sh.org>
 <1339976338.2372.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339976338.2372.2.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 09:38:58AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2012-06-15 at 09:56 +0900, Paul Mundt wrote:
> > Will do, thanks for testing.
> 
> Ping ? :-)
> 
> All the powerpc builds are still broken...
> 
Sent now, sorry about the delay! As I was about to send it earlier,
someone else reported an x86 build failure that looked related, so I held
off until I could properly test it (I didn't want to just trade one
platform breakage for another). In the end it was unrelated to the patch
in question.
