Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0E0QLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:11:53 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:49694 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab0E0QLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:11:52 -0400
Date: Thu, 27 May 2010 18:11:34 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100527161134.GA2690@citd.de>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com> <20100527154916.GA5585@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527154916.GA5585@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2010 11:49, Christoph Hellwig wrote:
> On Thu, May 27, 2010 at 05:37:36AM +0530, Jaswinder Singh Rajput wrote:
> > Hello,
> > 
> > I am trying to build 32 bit kernel image on 64-bit machine but after
> > 'make menuconfig' it automatically switches 32-bit to 64-bit.
> > 
> > Is this a BUG or did intentionally.
> 
> I think it's intentional, but I'm really annoyed by this behaviour.
> I really don't want my config to change from a normal make depending
> on uname output.  We do have a CONFIG_64BIT in .config which should
> be respected.  uname output is a good indicator for a previously
> unconfigured kernel, but shouldn't change settings for a fully
> congigured build.  Forgetting the linux32 command happens at least two
> dozen times to me everyday, leading to a few lost seconds that add
> up in the end.

Just use ARCH=x86. That ARCH respects CONFIG_64BIT from .config and 
"CONFIG_64BIT" is a config-option (the very first in menuconfig)





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

