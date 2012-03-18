Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2CRN3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 09:29:04 -0400
Received: from 1wt.eu ([62.212.114.60]:63428 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab2CRN3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 09:29:03 -0400
Date: Sun, 18 Mar 2012 14:28:55 +0100
From: Willy Tarreau <w@1wt.eu>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.32.59
Message-ID: <20120318132855.GK17033@1wt.eu>
References: <20120317130953.GA16926@1wt.eu> <4F65E1A6.3020302@arndnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65E1A6.3020302@arndnet.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, Mar 18, 2012 at 02:22:46PM +0100, Arnd Hannemann wrote:
> Hi,
> 
> Am 17.03.2012 14:09, schrieb Willy Tarreau:
> 
> > The updated 2.6.32.y git tree can be found at:
> >    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
> >   http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
> > 
> > The tree can be browsed on the gitweb interface:
> >   http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.32.y
> 
> Neither any commit after 2.6.32.58 nor the tag v2.6.32.59 seems to be available in the public git tree, yet.
> Forgot to push?

Greg was not available for the final push when I sent the announce yesterday
and I made a mistake in the pull request I sent him, further delaying the
update. This will be sorted out soon, don't worry.

Just for those who can't wait, I'm generally pushing there though it is
not official at all and may be removed or forced-updated without prior
notice (so don't track it) :

   http://git.kernel.org/?p=linux/kernel/git/wtarreau/for-greg.git;a=shortlog;h=refs/heads/linux-2.6.32.y

Regards,
Willy

