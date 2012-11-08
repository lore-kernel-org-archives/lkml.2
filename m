Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab2KHUFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:05:17 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:60141 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab2KHUFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:05:14 -0500
Subject: Re: scsi target, likely GPL violation
From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Reply-To: nab@risingtidesystems.com
To: Andy Grover <agrover@redhat.com>
Cc: Chris Friesen <chris.friesen@genband.com>, Jon Mason <jdmason@kudzu.us>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>
In-Reply-To: <509BE460.6010404@redhat.com>
References: <509A915B.30105@redhat.com>
	 <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
	 <509B117A.6070708@genband.com>  <509BE460.6010404@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Rising Tide Systems
Date: Thu, 08 Nov 2012 12:05:11 -0800
Message-ID: <1352405111.29589.476.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 08:57 -0800, Andy Grover wrote:
> On 11/07/2012 05:57 PM, Chris Friesen wrote:
> > On 11/07/2012 07:02 PM, Jon Mason wrote:
> >> I'm not a lawyer, nor do I play one on TV, but if
> >> I understand the GPL correctly, RTS only needs to provide the relevant
> >> source to their customers upon request.
> > 
> > Not quite.
> > 
> > Assuming the GPL applies, and that they have modified the code, then
> > they must either:
> > 
> > 1) include the source with the distributed binary
> > 
> > or
> > 
> > 2) include with the binary an offer to provide the source to *any* third
> > party
> 
> So you'd have me find one of their customers, and then get the source
> via your #2 method...
> 
> ...and then turn around and submit it to Nick since he's the target
> subsystem maintainer? Nick is probably the one who wrote it!
> 
> I'm happy to do that, but we should recognize something is seriously
> skewed when the person nominally in charge of the in-kernel code also
> has a vested interest in *not* seeing new features added, since it then
> competes better with his company's offering.
> 
> RTS is trying to use an "open core" business model. This works fine for
> BSD-licensed code or code originally authored entirely by you, but their
> code (all of it even the new stuff) is a derivative work of the Linux
> kernel source code, and the GPL says they need to contribute it back.
> 

Andy,

Accusing us of violating GPL is a serious legal claim.  

In fact, we are not violating GPL.  In short, this is because we wrote
the code you are referring to (the SCSI target core in our commercial
RTS OS product), we have exclusive copyright ownership of it, and this
code contains no GPL code from the community.  GPL obligations only
apply downstream to licensees, and not to the author of the code.  Those
who use the code under GPL are subject to its conditions; we are not.

As you know, we contributed the Linux SCSI target core, including the
relevant interfaces, to the Linux kernel.  To be clear, we wrote that
code entirely ourselves, so we have the right to use it as we please.
The version we use in RTS OS is a different, proprietary version, which
we also wrote ourselves.  However, the fact that we contributed a
version of the code to the Linux kernel does not require us to provide
our proprietary version to anyone.

If you want to understand better how dual licensing works, perhaps we
can talk off list.  But we don’t really have a responsibility to respond
to untrue accusations, nor to explain GPL, nor discuss our proprietary
code.

We’re very disappointed that Red Hat would not be more professional in
its communications about licensing compliance matters, particularly to a
company like ours that has been a major contributor to Linux and
therefore also to Red Hat’s own products.  So, while I invite you to
talk about this with us directly, I also advise you – respectfully – not
to make public accusations that are not true.  That is harmful to our
reputation – and candidly, it doesn’t reflect well on you or your
company.

--nab

