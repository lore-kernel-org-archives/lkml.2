Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0GET6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:58:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37126 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0GET6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QzvqlRy4Mwxw9kZKgmKwNsDaR59zupnTpkX/KCkhgqYgupz8j64u3Dw5GnNkbWBpnf
         pr4yul7b9o+6BGGNRQwTG8/X/u7we93xrRUTqVKdM5VgUaIDUnXeCmQ5d3v1VOddIKLy
         myKSOaZ9t+GdQehP0wn6Mqh0MWD3RjodNOV+M=
Date: Mon, 5 Jul 2010 21:58:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Ian Kent <raven@themaw.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       autofs@linux.kernel.org
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Message-ID: <20100705195837.GF5240@nowhere>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <4C3235C3.7050303@zytor.com> <20100705194759.GE5240@nowhere> <201007052152.55954.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007052152.55954.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 09:52:55PM +0200, Arnd Bergmann wrote:
> On Monday 05 July 2010 21:48:01 Frederic Weisbecker wrote:
> > On Mon, Jul 05, 2010 at 12:42:59PM -0700, H. Peter Anvin wrote:
> > > On 07/05/2010 12:24 PM, Frederic Weisbecker wrote:
> > > > 
> > > > Peter, if you're fine with this version. May I apply it?
> > > > Unless you have a tree for autofs.
> > > > 
> > > Ian Kent is the maintainer of autofs4 and patches for autofs4 should go
> > > through him (or acked by him.)
> > > 
> > > autofs 3 is officially unmaintained; I'm more than happy to have you
> > > push the autofs 3 bits of this patch.
> > 
> > Sure, I can split up the patch and integrate the autofs 3 part, I'll send
> > the standalone autofs4 version to Ian.
> 
> I think in this case it's really more appropriate to change both autofs3
> and autofs4 together, to avoid interdependencies. Whichever way Ian
> prefers (ack the patch or take it) would work though.
> 
> 	Arnd


Yeah indeed. Ian?

