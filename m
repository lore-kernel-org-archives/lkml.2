Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0L3NKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 08:10:34 -0500
Received: from relay3.sgi.com ([192.48.152.1]:41066 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751775Ab0L3NKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 08:10:33 -0500
Date: Thu, 30 Dec 2010 07:10:31 -0600
From: Robin Holt <holt@sgi.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Robin Holt <holt@sgi.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] init: rename CONFIG_EMBEDDED to CONFIG_EXPERT
Message-ID: <20101230131031.GF3260@sgi.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
 <20101230124535.GA3306@sgi.com>
 <201012301350.28862.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012301350.28862.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 01:50:28PM +0100, Arnd Bergmann wrote:
> On Thursday 30 December 2010, Robin Holt wrote:
> > Doesn't this patch series break the 'bisectable' rule for patches?
> > I think you can get by with adding a CONFIG_EXPERT selects CONFIG_EMBEDDED
> > in the first patch and the last patch removing that same selects.
> 
> How about leaving it that way during the merge window even? That would
> help people sending git pull requests that add new dependencies on
> CONFIG_EMBEDDED. David can submit another patch that removes the
> temporary CONFIG_EMBEDDED option along with any new users in -rc2
> or for 2.6.39 then.

That would be fine with me, but I don't think my vote counts for much.
I was just trying to help prevent the bisectability of your patchset.

Robin
