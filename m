Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0DZWJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:09:47 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46637 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0DZWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MaBG8bJzzuMrWqV/Avp5E7qtHMfMiwWrNsWeUvHV/GIekMZjEo+z4Xkn5xe7E/PapQ
         Lvmwl3iOsjjAzyByOeQFj7DpoMRpbMSpKxp094jRNw0ZXXDfP+ituS6Ah6k6AIgQtqoQ
         obgMdptUSivkDxBT+7dlNNTTH9ttkD5FkhU8I=
Date: Tue, 27 Apr 2010 00:09:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       jblunck@suse.de, mingo@elte.hu, jkacur@redhat.com
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100426220936.GB5695@nowhere>
References: <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org> <201004261030.21751.arnd@arndb.de> <alpine.LFD.2.00.1004261104310.3739@i5.linux-foundation.org> <20100426.134207.229746269.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426.134207.229746269.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 01:42:07PM -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 26 Apr 2010 11:08:39 -0700 (PDT)
> 
> > NOTE! This has gone through a "allmodconfig" (with staging drivers), but 
> > only on x86-64. There are quite probably missing architecture conversions
> > and/or drivers. But this should be the bulk of them.
> 
> "allmodconfig" on sparc64 passes with this patch too, just FYI...


Thanks!

I've queued it for the next merge window in

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/ioctl

