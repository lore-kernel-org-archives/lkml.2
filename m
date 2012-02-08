Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab2BHNyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:54:31 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56525 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab2BHNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:54:23 -0500
Subject: Re: [RFC][PATCH v1 0/2] integrity: module integrity verification
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@ozlabs.org>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jcm@redhat.com>
Date: Wed, 08 Feb 2012 08:45:09 -0500
In-Reply-To: <87bopagqn4.fsf@rustcorp.com.au>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com>
	 <alpine.LRH.2.00.1202061250400.16907@tundra.namei.org>
	 <CALLzPKZSWSp6r-5e1c1Z6qOH6C0DcOz=LHJ20Y468SQE6UU1ww@mail.gmail.com>
	 <87zkcuh8iq.fsf@rustcorp.com.au>
	 <CALLzPKZRUTaOE8afXD1b=Kd6fOaisOpAW+XGJMi7uHdE0sEgFw@mail.gmail.com>
	 <87bopagqn4.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1328708710.2679.4.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020813-1976-0000-0000-00000A498753
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 10:09 +1030, Rusty Russell wrote:
> On Tue, 7 Feb 2012 23:18:38 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
> > On Tue, Feb 7, 2012 at 7:13 PM, Rusty Russell <rusty@ozlabs.org> wrote:
> > > On Mon, 6 Feb 2012 08:59:00 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
> > >> On Mon, Feb 6, 2012 at 3:51 AM, James Morris <jmorris@namei.org> wrote:
> > >> > On Wed, 1 Feb 2012, Dmitry Kasatkin wrote:
> > >> >
> > >> >> Hi,
> > >> >>
> > >> >> Here is another module verification patchset, which is based on the recently
> > >> >> upstreamed digital signature support used by EVM and IMA-appraisal.
> > >> >
> > >> > You should cc: Rusty on any changes to the module code.
> > >> >
> > >>
> > >> Hello,
> > >>
> > >> Mimi already has pointed that out.
> > >> I have sent him an email with the link..
> > >
> > > Thanks.
> > >
> > > Using an external signature (via cmdline arguments) is simple, at
> > > least.  Not sure what the userspace side of this looks like?
> > >
> > 
> > Hello,
> > 
> > There are couple of patches for modprobe and insmod...
> > 
> > You could see them on the top at:
> > http://linux-ima.git.sourceforge.net/git/gitweb.cgi?p=linux-ima/module-init-tools.git;a=summary
> > 
> > It first tries to read signature from xattr, then from file...
> > "modprobe -v" will show 'ima='  parameter with signature.
> > 
> > - Dmitry
> 
> The problem is that distributions tend to have two variants of modules:
> stripped and unstripped.  Thus you may want to support multiple
> signatures, any *one* of which may match.
> 
> I've cc'd the module-init-tools and libkmod maintainers for their
> comments, too.
> 
> Cheers,
> Rusty.

Hi Rusty,

As a distro knows what it is shipping, why would you need support for
both stripped/unstripped versions.  Unless "stripping" occurs post
install.  Perhaps something similar to 'prelink'?

thanks,

Mimi

