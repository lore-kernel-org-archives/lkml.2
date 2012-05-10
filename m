Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab2EJPUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:20:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2EJPUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:20:14 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=aHbdvXMWeFoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=_AeW9tImtebl1KcTIuQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336663210.14207.225.camel@gandalf.stny.rr.com>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>,
        gregkh <gregkh@linuxfoundation.org>
Date: Thu, 10 May 2012 11:20:10 -0400
In-Reply-To: <20120510151254.GD32700@aftab.osrc.amd.com>
References: <4FAA6802.9070506@redhat.com>
	 <20120509132237.GD22737@aftab.osrc.amd.com> <4FAA7649.5080606@redhat.com>
	 <20120509140632.GG22737@aftab.osrc.amd.com> <4FAA7C1A.3020406@redhat.com>
	 <20120509142456.GH22737@aftab.osrc.amd.com> <4FABBFAF.20809@redhat.com>
	 <20120510134136.GC31257@aftab.osrc.amd.com> <4FABD653.7060401@redhat.com>
	 <4FABD9F0.6050008@redhat.com> <20120510151254.GD32700@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 17:12 +0200, Borislav Petkov wrote:
> On Thu, May 10, 2012 at 12:08:32PM -0300, Mauro Carvalho Chehab wrote:
> > There's also another technical reason to give an acronym to the EDAC
> > version that actually works: changeset numbers are not consistent
> > within distributions (or other trees, like -stable - although this 60+
> > patch series probably won't fit on -stable merging criteria).
> >
> > Also, this EDAC changeset 60+ patch series can't be represented by a
> > single changeset, and requires userspace changes in order to get a
> > proper representation model for memories.

Is this a redesign of EDAC or just a fix of it? Does this require
userspace to use a new ABI?

> >
> > Tagging the EDAC core version with a name helps a lot when dealing
> > with all the unsolved bugzillas that will be closed by backporting
> > this patch series in order to fix the serious EDAC core bug that
> > were providing fake information to the end user for all Intel memory
> > controllers manufactured after 2005.
> 
> edac_module.c:18:#define EDAC_VERSION "Ver: 2.1.0"
> 
> Increment that in the last patch.

If this is redesigning a subsystem and changing the ABI for userspace
than a new name is appropriate. Much like ipchains turning into
iptables.


But if this is just fixing the subsystem where userspace sees no
difference, than the same name fits.

-- Steve


