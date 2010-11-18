Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0KROXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:23:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab0KROXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:23:47 -0500
Date: Thu, 18 Nov 2010 09:23:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Pavel Machek <pma@sysgo.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        akpm@linux-foundation.org, randy.dunlap@oracle.com
Subject: Re: kexec documentation missing, bad links in kdump.txt
Message-ID: <20101118142322.GA13933@redhat.com>
References: <20101118095015.GA12071@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118095015.GA12071@pma.sysgo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:50:15AM +0100, Pavel Machek wrote:
> Hi!
> 
> Where can one get kexec documentation?
> 
> (In particular, we are trying to get it to boot on ARM board, and
> wonder if something like CONFIG_RELOCATABLE_KERNEL is needed.)
> 

For kexec you will not need CONFIG_RELOCATABLE_KERNEL. But if you also
want to use kdump and use same bzImage as first kernel then you will
need relocatable kernel support.

For kdump I had done two presentations at OLS. You might find little
bit of kexec details too.

Kdump: Smarter, Easier, Trustier
http://www.kernel.org/doc/ols/2007/ols2007v1-pages-167-178.pdf

Kdump, a kexec based crash dumping mechanism.
http://lse.sourceforge.net/kdump/documentation/ols2oo5-kdump-paper.pdf

thanks
Vivek
 
> Unfortunately, only pieces mentioning kexec are kdump pieces
> (Documentation/kdump/kdump.txt), and links there, such as
> 
> http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz
> 
> http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html
> 
> http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git
> 
> are no longer valid :-(.
> 								Pavel
