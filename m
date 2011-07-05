Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1GEQPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:15:15 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46006 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732Ab1GEQPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:15:07 -0400
X-Sasl-enc: aAr8o/AlSbS5NAbiRDPuatNnwuWSn2zcw44NKReOXCVM 1309882506
Date: Tue, 5 Jul 2011 09:12:44 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 34/40] Staging: hv: storvsc: Add the contents of
 hyperv_storage.h to storvsc_drv.c
Message-ID: <20110705161244.GA24766@kroah.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-34-git-send-email-kys@microsoft.com>
 <20110630194530.GE22707@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480816C297@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110701081601.GB28322@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480816C44C@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480816C44C@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 12:48:44PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Friday, July 01, 2011 4:16 AM
> > To: KY Srinivasan
> > Cc: Christoph Hellwig; gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > Abhishek Kane (Mindtree Consulting PVT LTD); Hank Janssen
> > Subject: Re: [PATCH 34/40] Staging: hv: storvsc: Add the contents of
> > hyperv_storage.h to storvsc_drv.c
> > 
> > On Thu, Jun 30, 2011 at 08:13:51PM +0000, KY Srinivasan wrote:
> > > > > Add the contents of hyperv_storage.h to storvsc_drv.c and cleanup
> > > > storvsc_drv.c.n
> > > >
> > > > I'd at least leave the first half of the header that defines the
> > > > protocol around.
> > >
> > > I only got rid of the block comment at the start of hyperv_storage.h
> > > and consolidated the include files. Nothing of substance was deleted.
> > 
> > I meant to say keeping a separate header file for the protocol defintion
> > might be a good idea.  That way it is kept separate from the
> > implementation details
> > 
> Ok; I get it. Although, a while ago as I was cleaning up the header files
> In preparation to exiting staging, Greg had indicated that each driver
> should, if possible be a single file. I merged the relevant files to comply
> with that directive. 

Well, do what makes sense.

