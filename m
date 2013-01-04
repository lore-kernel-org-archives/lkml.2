Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3ADOeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:34:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22610 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3ADOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:34:42 -0500
Date: Fri, 4 Jan 2013 09:34:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
Message-ID: <20130104143412.GB3334@phenom.dumpdata.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <50DBC856.6030208@zytor.com>
 <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
 <50DC58C4.3000307@citrix.com>
 <874nj7qsor.fsf@xmission.com>
 <50E41973.9050705@citrix.com>
 <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 03:22:57PM +0100, Daniel Kiper wrote:
> On Wed, Jan 02, 2013 at 11:26:43AM +0000, Andrew Cooper wrote:
> > On 27/12/12 18:02, Eric W. Biederman wrote:
> > >Andrew Cooper<andrew.cooper3@citrix.com>  writes:
> > >
> > >>On 27/12/2012 07:53, Eric W. Biederman wrote:
> > >>>The syscall ABI still has the wrong semantics.
> > >>>
> > >>>Aka totally unmaintainable and umergeable.
> > >>>
> > >>>The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.
> > >>There are two requirements pulling at this patch series, but I agree
> > >>that we need to clarify them.
> > >It probably make sense to split them apart a little even.
> > >
> > >
> >
> > Thinking about this split, there might be a way to simply it even more.
> >
> > /sbin/kexec can load the "Xen" crash kernel itself by issuing
> > hypercalls using /dev/xen/privcmd.  This would remove the need for
> > the dom0 kernel to distinguish between loading a crash kernel for
> > itself and loading a kernel for Xen.
> >
> > Or is this just a silly idea complicating the matter?
> 
> This is impossible with current Xen kexec/kdump interface.
> It should be changed to do that. However, I suppose that
> Xen community would not be interested in such changes.

Why not? What is involved in it? IMHO I believe anybody would
welcome a new clean design that solves this thorny problem?
