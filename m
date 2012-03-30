Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab2C3KCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:02:07 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:41736 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab2C3KCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:02:03 -0400
Date: Fri, 30 Mar 2012 12:02:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20120330100200.GA5212@merkur.ravnborg.org>
References: <20120330.033947.681145423995124443.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330.033947.681145423995124443.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 03:39:47AM -0400, David Miller wrote:
> 
> This just fixes build fallout due to recent changes that went
> int your tree.

I did not fix sparc32 build - will look at it later today.
I assume it is equally trivial to fix.


	Sam
