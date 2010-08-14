Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0HNVkC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:40:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272Ab0HNVkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:40:01 -0400
Date: Sat, 14 Aug 2010 14:01:35 -0700
From: Greg KH <gregkh@suse.de>
To: "Gabor Z. Papp" <gzp@papp.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.52 stable review
Message-ID: <20100814210135.GA7745@suse.de>
References: <20100813214704.GA18960@kroah.com>
 <x6r5i1o3dc@gzp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x6r5i1o3dc@gzp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 01:11:43PM +0200, Gabor Z. Papp wrote:
> * Greg KH <gregkh@suse.de>:
> 
> | If I could get some people to please test this -rc release?
> 
> BTW seems like 2.6.27 no more combatible with GNU Make 3.82:
> 
> $ make oldconfig
> Makefile:443: *** mixed implicit and normal rules.  Stop.
> 
> Same with line 1609.

Nothing has changed with the main Makefile with the exception of
changing the version number for a very long time.

Did something else change on your system?

odd,

greg k-h
