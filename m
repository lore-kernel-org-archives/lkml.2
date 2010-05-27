Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab0E0Qfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:35:32 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:57060 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab0E0Qfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:35:31 -0400
Date: Thu, 27 May 2010 18:35:12 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100527163512.GA3980@citd.de>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com> <20100527154916.GA5585@infradead.org> <20100527161134.GA2690@citd.de> <20100527161347.GA5005@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527161347.GA5005@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2010 12:13, Christoph Hellwig wrote:
> On Thu, May 27, 2010 at 06:11:34PM +0200, Matthias Schniedermeyer wrote:
> > Just use ARCH=x86. That ARCH respects CONFIG_64BIT from .config and 
> > "CONFIG_64BIT" is a config-option (the very first in menuconfig)
> 
> Which is an obsolute pain to type, even worse than doing a linux32 call
> first.  Really, a simple
> 
> 	make
> 
> should default to do the right thing.

In my case it's wonderful, i compile several kernels with different 
bitnesses for differnt machines and with ARCH=x86 i don't have to 
differentiate between an i386 or x86_64 target.

for dat in a b c d; do make ARCH=x86 O=../$dat ; done





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

