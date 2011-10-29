Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab1J2OJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 10:09:57 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:53712 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab1J2OJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 10:09:56 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Topic: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Index: AQHMk/Yfbv94uVs6kUmFh5QHJPmlm5WSkYKA//+MPrCAAIjtgP//i45QgAEkuICAAAnN4A==
Date: Sat, 29 Oct 2011 14:09:55 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA5443E@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1319645321-9770-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1110282026360.3541@pobox.suse.cz>
 <6E21E5352C11B742B20C142EB499E0481AA531D4@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20111028200315.GA30918@suse.de>
 <6E21E5352C11B742B20C142EB499E0481AA53219@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20111029063409.GB2207@suse.de>
In-Reply-To: <20111029063409.GB2207@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Saturday, October 29, 2011 2:34 AM
> To: KY Srinivasan
> Cc: Jiri Kosina; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; Dmitry Torokhov
> Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> 
> On Fri, Oct 28, 2011 at 08:28:11PM +0000, KY Srinivasan wrote:
> > > > The guest cannot survive a malicious host; so I think it is safe to say that the
> > > > guest can assume the host is following the protocol.
> > >
> > > That's not good for a very large number of reasons, not the least being
> > > that we have no idea how secure the hyperv hypervisor is, so making it
> > > so that there isn't an obvious hole into linux through it, would be a
> > > good idea.
> > >
> > > And yes, I'd say the same thing if this was a KVM or Xen driver as well.
> > > Please be very defensive in this area of the code, especially as there
> > > are no performance issues here.
> >
> > In the chain of trust, the hypervisor and the host are the foundations
> > as far as the guest is concerned, since both the hypervisor and the host
> > can affect the guest in ways that the guest has no obvious way to protect itself.
> 
> That's true.
> 
> > If the hypervisor/host have security holes, there is not much you can do in the
> guest
> > to deal with it.
> > In this case, I can add checks but I am not sure how useful it is.
> 
> I would prefer to see them here, just to be safe, it can not hurt,
> right?

I have added a check in the patches I sent out yesterday.

Regards,

K. Y
> 
> 
> greg k-h

