Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab0KRSIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:08:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17918 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab0KRSIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:08:09 -0500
Date: Thu, 18 Nov 2010 10:06:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Pavel Machek <pma@sysgo.com>, kernel list <linux-kernel@vger.kernel.org>,
        horms@verge.net.au, akpm@linux-foundation.org, randy.dunlap@oracle.com
Subject: Re: kexec documentation missing, bad links in kdump.txt
Message-Id: <20101118100647.7c8395de.randy.dunlap@oracle.com>
In-Reply-To: <20101118142322.GA13933@redhat.com>
References: <20101118095015.GA12071@pma.sysgo.com>
	<20101118142322.GA13933@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 09:23:22 -0500 Vivek Goyal wrote:

> On Thu, Nov 18, 2010 at 10:50:15AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > Where can one get kexec documentation?
> > 
> > (In particular, we are trying to get it to boot on ARM board, and
> > wonder if something like CONFIG_RELOCATABLE_KERNEL is needed.)
> > 

Simon, Vivek --
can you get someone to update the Documentation/ files, please?


> For kexec you will not need CONFIG_RELOCATABLE_KERNEL. But if you also
> want to use kdump and use same bzImage as first kernel then you will
> need relocatable kernel support.
> 
> For kdump I had done two presentations at OLS. You might find little
> bit of kexec details too.
> 
> Kdump: Smarter, Easier, Trustier
> http://www.kernel.org/doc/ols/2007/ols2007v1-pages-167-178.pdf
> 
> Kdump, a kexec based crash dumping mechanism.
> http://lse.sourceforge.net/kdump/documentation/ols2oo5-kdump-paper.pdf
> 
> thanks
> Vivek
>  
> > Unfortunately, only pieces mentioning kexec are kdump pieces
> > (Documentation/kdump/kdump.txt), and links there, such as
> > 
> > http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz
> > 
> > http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html
> > 
> > http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git
> > 
> > are no longer valid :-(.
> > 								Pavel
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
