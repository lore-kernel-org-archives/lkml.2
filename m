Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab1JNUYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:24:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41959 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab1JNUYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:24:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=BnwZjTtF1N8PBeVcGtMLPQWX7wMBTY4NqYun8Fzm1oG8gSUHskSz4K08oA6BL0//S
	cnbEwYM+O446+rQfeGxSQ==
Date: Fri, 14 Oct 2011 13:23:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jan Steinke <jan.steinke@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Reporting Kernel Bugs
In-Reply-To: <loom.20111014T220901-636@post.gmane.org>
Message-ID: <alpine.DEB.2.00.1110141321250.24783@chino.kir.corp.google.com>
References: <4E95D7A6.6010603@canonical.com> <alpine.LRH.2.00.1110122011360.29079@twin.jikos.cz> <loom.20111014T220901-636@post.gmane.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Jan Steinke wrote:

> > Just send an e-mail to appropriate mailinglist and CC 
> > responsible maintainer(s).
> > 
> > That's what many people prefer to bugzilla anyway.
> > 
> 
> How do I know the responsible maintainer(s)? How do I know if the bug is 
> confirmed or accepted?
> 

If you can figure out what subsystem is the likely source of the issue, 
then you can check the MAINTAINERS file for the appropriate people and 
mailing list.  If there's a panic or oops, find the source file that is to 
blame and use ./scripts/get_maintainer.pl -f <file>.  Otherwise, just 
report some unknown, untriaged error directly to 
linux-kernel@vger.kernel.org and be sure to cc Andrew Morton 
<akpm@linux-foundation.org> who used to go through the kernel.org bugzilla 
quite often and send bug reports in the right direction.
