Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2KICIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:08:20 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:56443 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2KICIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:08:19 -0500
Subject: Re: scsi target, likely GPL violation
From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Reply-To: nab@risingtidesystems.com
To: Andy Grover <agrover@redhat.com>
Cc: Chris Friesen <chris.friesen@genband.com>, Jon Mason <jdmason@kudzu.us>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>
In-Reply-To: <509C22B2.8010600@redhat.com>
References: <509A915B.30105@redhat.com>
	 <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
	 <509B117A.6070708@genband.com>  <509BE460.6010404@redhat.com>
	 <1352405111.29589.476.camel@haakon2.linux-iscsi.org>
	 <509C22B2.8010600@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Rising Tide Systems
Date: Thu, 08 Nov 2012 18:08:16 -0800
Message-ID: <1352426896.29589.512.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 13:22 -0800, Andy Grover wrote:
> On 11/08/2012 12:05 PM, Nicholas A. Bellinger wrote:
> > Accusing us of violating GPL is a serious legal claim.  
> > 
> > In fact, we are not violating GPL.  In short, this is because we wrote
> > the code you are referring to (the SCSI target core in our commercial
> > RTS OS product), we have exclusive copyright ownership of it, and this
> > code contains no GPL code from the community.  GPL obligations only
> > apply downstream to licensees, and not to the author of the code.  Those
> > who use the code under GPL are subject to its conditions; we are not.
> 
> Hi Nick, thanks for finally responding.
> 
> I believe your argument is wrong for two reasons.
> 
> First, LIO is a derivative work of the Linux kernel. It uses kernel APIs
> and headers. You ship Linux as part of RTS OS. Even if you had not asked
> for LIO to be included in mainline, this would still be true and would
> require you to publish your changes under the GPLv2.
> 
> Second, you claim you hold exclusive copyright for the code. Not true.
> One example: on http://www.risingtidesystems.com/storage.html you claim
> support for FCoE. You didn't build tcm_fc, Intel did. Under the GPLv2.
> Furthermore, SRP support came from SCST, iirc. None of these
> contributors gave RTS any right to use their copyrighted code except
> under the conditions of the GPLv2.
> 

Andy,

Support for certified VAAI is part of our commercial target core. The
target core constitutes a stand-alone kernel subsystem of which we are
the sole copyright owners. In addition, our target contains a number of
backend drivers, of which we are also the sole copyright owners, and a
number of fabric modules, of which some we are the sole copyright
owners, and of which others we are not, as you pointed out. A
substantial fraction of the code of which we own the sole copyright was
certified by BlackDuck Software as early as in 2007. 

We contributed our target to the Linux kernel in 2010, at which point we
forked it into the upstream version and our commercial version. These
target versions have been diverging over time, as we keep maintaining
either one of them independently.

For our commercial target core, we only use Linux kernel symbols that
are not marked as GPL. In addition, we define the API between the target
core and its backend drivers and between the target core and its fabric
modules, we define the ABI between the target core and user space, and
we have done so years before our code went upstream into the Linux
kernel.

We have been contributing substantially to the upstream target version
to keep improving Linux. We have also been improving our commercial
target version to afford the considerable effort and expense involved in
our ongoing Linux contributions, and to compensate other top Linux
kernel developers for their contributions to the upstream target
version.

RTS OS is based on a stock Linux enterprise kernel. This Linux kernel
has naturally the ability to load either one of our standalone
self-contained target module versions without any modifications.

Again, we’re very disappointed by these untrue and highly damaging
accusations from Red Hat. We have generously contributed to Linux, and
we have generously supported the Linux community for their contributions
to our upstream target and other Linux kernel parts. You have mostly
just incorporated our work into Red Hat’s products.

So yes, Andy, please start behaving properly, so that at least we can
get back to making Linux better.

--nab

