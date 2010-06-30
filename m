Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0F3AtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:49:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52914 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab0F3AtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:49:16 -0400
Date: Tue, 29 Jun 2010 17:49:12 -0700
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4] security: Yama LSM
Message-ID: <20100630004911.GI4837@outflux.net>
References: <20100628184200.GU4175@outflux.net>
 <alpine.LRH.2.00.1006300854170.14620@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1006300854170.14620@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 30, 2010 at 09:18:32AM +1000, James Morris wrote:
> On Mon, 28 Jun 2010, Kees Cook wrote:
> 
> > This adds the Yama Linux Security Module to collect several security
> > features (symlink, hardlink, and PTRACE restrictions) that have existed
> > in various forms over the years and have been carried outside the mainline
> > kernel by other Linux distributions like Openwall and grsecurity.
> > 
> > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> 
> There were no further complaints, and we seem to have reached a workable 
> consensus on the topic.
> 
> It's not clear yet whether existing LSMs will modify their base policies 
> to incorporate these protections, utilize the Yama code more directly, or 
> implement some combination of both.

I'm hoping we can implement really simple chaining -- nothing fancy.
Trying to chain comprehensive LSMs seems like it will always fail, but
putting little LSMs in front of big LSMs seems like an easy win.

> If you're a user of an existing LSM and want these protections, bug the 
> developers for a solution :-)
> 
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Thanks!

-Kees

-- 
Kees Cook
Ubuntu Security Team
