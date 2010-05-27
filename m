Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0E0QOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:14:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33330 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab0E0QN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:13:59 -0400
Date: Thu, 27 May 2010 12:13:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100527161347.GA5005@infradead.org>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com> <20100527154916.GA5585@infradead.org> <20100527161134.GA2690@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527161134.GA2690@citd.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 06:11:34PM +0200, Matthias Schniedermeyer wrote:
> Just use ARCH=x86. That ARCH respects CONFIG_64BIT from .config and 
> "CONFIG_64BIT" is a config-option (the very first in menuconfig)

Which is an obsolute pain to type, even worse than doing a linux32 call
first.  Really, a simple

	make

should default to do the right thing.

