Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1DZTUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:20:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33214 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1DZTUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XQtG7TbHQS4QzOo+MbQN5n8Muk59ir7u1tAou9gr4hWlfqs1TB1wCPYIvb0JYNODMd
         DrWM2jsLS55WoBvMKI9DUQST96vGJx+jmrJOIZOxXr+gk4lxLo9+7xfDg4zSkzYn6X9k
         jT9lFWR3VzLUxobUWwAUayUg/BwfYxCs6E9Qo=
Date: Tue, 26 Apr 2011 22:20:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110426192029.GA4686@p183>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
 <20110426190531.GA4556@p183>
 <1303845468.18763.32.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303845468.18763.32.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 03:17:48PM -0400, Steven Rostedt wrote:
> On Tue, 2011-04-26 at 22:05 +0300, Alexey Dobriyan wrote:
> > On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:

> > >  /**
> > > + * streq - Are two strings equal?
> > > + * @a: first string
> > > + * @b: second string
> > > + *
> > > + * Example:
> > > + *	if (streq(argv[1], "--help"))
> > > + *		printf("%s\n", "This help");
> 
> Userspace example?

The point is that function is trivial, and if someone doesn't
understand it, he should read some Kernighan and Ritchie first.
