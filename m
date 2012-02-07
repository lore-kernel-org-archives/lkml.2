Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2BHATW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:19:22 -0500
Received: from ozlabs.org ([203.10.76.45]:37085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab2BHATV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:19:21 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        David Howells <dhowells@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jcm@redhat.com>
Subject: Re: [RFC][PATCH v1 0/2] integrity: module integrity verification
In-Reply-To: <CALLzPKZRUTaOE8afXD1b=Kd6fOaisOpAW+XGJMi7uHdE0sEgFw@mail.gmail.com>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1202061250400.16907@tundra.namei.org> <CALLzPKZSWSp6r-5e1c1Z6qOH6C0DcOz=LHJ20Y468SQE6UU1ww@mail.gmail.com> <87zkcuh8iq.fsf@rustcorp.com.au> <CALLzPKZRUTaOE8afXD1b=Kd6fOaisOpAW+XGJMi7uHdE0sEgFw@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 08 Feb 2012 10:09:11 +1030
Message-ID: <87bopagqn4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012 23:18:38 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
> On Tue, Feb 7, 2012 at 7:13 PM, Rusty Russell <rusty@ozlabs.org> wrote:
> > On Mon, 6 Feb 2012 08:59:00 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
> >> On Mon, Feb 6, 2012 at 3:51 AM, James Morris <jmorris@namei.org> wrote:
> >> > On Wed, 1 Feb 2012, Dmitry Kasatkin wrote:
> >> >
> >> >> Hi,
> >> >>
> >> >> Here is another module verification patchset, which is based on the recently
> >> >> upstreamed digital signature support used by EVM and IMA-appraisal.
> >> >
> >> > You should cc: Rusty on any changes to the module code.
> >> >
> >>
> >> Hello,
> >>
> >> Mimi already has pointed that out.
> >> I have sent him an email with the link..
> >
> > Thanks.
> >
> > Using an external signature (via cmdline arguments) is simple, at
> > least.  Not sure what the userspace side of this looks like?
> >
> 
> Hello,
> 
> There are couple of patches for modprobe and insmod...
> 
> You could see them on the top at:
> http://linux-ima.git.sourceforge.net/git/gitweb.cgi?p=linux-ima/module-init-tools.git;a=summary
> 
> It first tries to read signature from xattr, then from file...
> "modprobe -v" will show 'ima='  parameter with signature.
> 
> - Dmitry

The problem is that distributions tend to have two variants of modules:
stripped and unstripped.  Thus you may want to support multiple
signatures, any *one* of which may match.

I've cc'd the module-init-tools and libkmod maintainers for their
comments, too.

Cheers,
Rusty.
