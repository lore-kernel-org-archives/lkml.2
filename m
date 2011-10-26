Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1JZXIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:08:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18929 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1JZXIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:08:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=fNWgYvhIe5+CD6lpe7AA8RIA7QX88gptJz8QoSAkHe0ku/BPex1rIF7JapI7i6LRD
	ch9H4R6ggv7KgvIYKA7Ww==
Date: Wed, 26 Oct 2011 16:08:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: improve error message for p1-check
In-Reply-To: <1319669467.21924.18.camel@Joe-Laptop>
Message-ID: <alpine.DEB.2.00.1110261607150.6982@chino.kir.corp.google.com>
References: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de> <alpine.DEB.2.00.1110261329240.23111@chino.kir.corp.google.com> <1319669467.21924.18.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, Joe Perches wrote:

> > > The old error message was not precise. State now explicitly that the
> > > prefix exists as a file/directory. Also change the conclusion ("appears
> > > to be") into an instruction ("make sure").
> > Why can't we suppress this warning unless both prefixes appear as files or 
> > directories in the cwd?  ('a' and 'b' if using git format-patch)
> 
> I sent a suggested patch that checked $root/$patched_file
> https://lkml.org/lkml/2011/10/19/257
> 

So we need a combination of the two approaches then, it makes sense to 
only emit the warning if the patched file exists in both prefixes.
