Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1GFRrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:47:05 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:37669 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755183Ab1GFRrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:47:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PFE7piQgVZxkYwjpor2h4SW1+3GdgtTU5fecrY/Zmuiux7pCi/EbYIbxMVl99FT9hhH2e563xd3Y15qsQb6oA6Y5J38QDZZu0VdJFUGT/AIsqE28EnwgTRJQ+6aF0TIq;
Date: Wed, 6 Jul 2011 10:46:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhutchings@solarflare.com, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net
Subject: Re: [PATCH 0/5 v2] PCI: fix cardbus and sriov regressions
Message-ID: <20110706104648.312ba4c7@jbarnes-desktop>
In-Reply-To: <20110706085316.GA3543@ram-ThinkPad-T61>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
	<CA+55aFwo-48yKu+raRF3B9n1mqd1qV35eDq56Yi+erPygkuTvA@mail.gmail.com>
	<20110706085316.GA3543@ram-ThinkPad-T61>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011 01:53:16 -0700
Ram Pai <linuxram@us.ibm.com> wrote:

> On Sun, Jul 03, 2011 at 02:30:00PM -0700, Linus Torvalds wrote:
> > and I'd really change the function argument to take that kind of
> > simplified thing instead.
> > 
> > And that cleanup/re-organization would be prime material for a totally
> > independent patch that changes no semantics at all, just prepares for
> > the other changes.
> > 
> > That way the final "patch 2" would be smaller and do the semantic
> > changes, instead of being a mix of semantic changes and infrastructure
> > changes.
> > 
> > And some of the cleanup stuff I could merge for 3.0 just to make things easier.
> > 
> > Hmm?
> 
> Here is a cleaned up patch that just adds functionality to kernel/resource.c
> It does make a small semantic addition to allocate_resource(), where it reallocates
> the resource with a newer size if that resource was already allocated.
> 
> Will this be acceptable for 3.0.0?

Up to Linus, I have no problem with the patch though, it seems like a
good cleanup and is good to keep separate from the other patches.  Once
it lands I can queue up the dependent patches in -next.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
