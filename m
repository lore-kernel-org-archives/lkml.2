Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2BHSDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:03:54 -0500
Received: from ozlabs.org ([203.10.76.45]:53556 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab2BHSDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:03:51 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jcm@redhat.com>
Subject: Re: [RFC][PATCH v1 0/2] integrity: module integrity verification
In-Reply-To: <CALLzPKb=6hSAW0-QxEhkH8wih8c20cLqcLVjm+CcXBGp0a901Q@mail.gmail.com>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1202061250400.16907@tundra.namei.org> <CALLzPKZSWSp6r-5e1c1Z6qOH6C0DcOz=LHJ20Y468SQE6UU1ww@mail.gmail.com> <87zkcuh8iq.fsf@rustcorp.com.au> <CALLzPKZRUTaOE8afXD1b=Kd6fOaisOpAW+XGJMi7uHdE0sEgFw@mail.gmail.com> <87bopagqn4.fsf@rustcorp.com.au> <1328708710.2679.4.camel@falcor> <CALLzPKb=6hSAW0-QxEhkH8wih8c20cLqcLVjm+CcXBGp0a901Q@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 09 Feb 2012 04:32:57 +1030
Message-ID: <8762fhgq3y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012 16:02:28 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
> On Wed, Feb 8, 2012 at 3:45 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Wed, 2012-02-08 at 10:09 +1030, Rusty Russell wrote:
> >> The problem is that distributions tend to have two variants of modules:
> >> stripped and unstripped.  Thus you may want to support multiple
> >> signatures, any *one* of which may match.
> >>
> >> I've cc'd the module-init-tools and libkmod maintainers for their
> >> comments, too.
> > Hi Rusty,
> >
> > As a distro knows what it is shipping, why would you need support for
> > both stripped/unstripped versions.  Unless "stripping" occurs post
> > install.  Perhaps something similar to 'prelink'?
> 
> How are they distributed? In separate packages?
> And striped during package creation?
> Then during package building, before archiving, signing tool is simply
> invoked for each binary package,
> so "same" modules from different packages will get own signature.
> 
> Or it goes some other way?

I don't know.  Perhaps it isn't an issue; David Howells and Jon Masters
might have comments.

Cheers,
Rusty.
