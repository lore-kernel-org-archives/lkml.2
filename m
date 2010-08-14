Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738Ab0HNNnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 09:43:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab0HNNnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 09:43:25 -0400
Date: Sat, 14 Aug 2010 06:42:54 -0700
From: Greg KH <gregkh@suse.de>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Call traces w/ 2.6.35.2 (not w/ 2.6.35.1 plus 2.6.35.2-rc1)
Message-ID: <20100814134254.GC17430@suse.de>
References: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 08:20:26AM +0200, Sedat Dilek wrote:
> Hi Greg,
> 
> looks like 2.6.35.2 misses some fixes from 2.6.35.2-rc1?

Huh?  I don't understand what you are trying to show here at all.

> sd@tbox:~/src/linux-2.6/patches/upstream$ cat patch-2.6.35.1
> patch-2.6.35.2-rc1 > new.patch
> 
> sd@tbox:~/src/linux-2.6/patches/upstream$ grep "diff --git" new.patch | wc -l
> 132
> 
> sd@tbox:~/src/linux-2.6/patches/upstream$ grep "diff --git"
> patch-2.6.35.2 | wc -l
> 128
> 
> Unfortunately, a kernel patched w/ 2.6.35.2 causes Call traces here.

And these are also showing up on Linus's tree right now as well?  Have
you reported them?

thanks,

greg k-h
