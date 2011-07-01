Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1GAMsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:48:46 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:17400 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1GAMsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:48:45 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 34/40] Staging: hv: storvsc: Add the contents of
 hyperv_storage.h to storvsc_drv.c
Thread-Topic: [PATCH 34/40] Staging: hv: storvsc: Add the contents of
 hyperv_storage.h to storvsc_drv.c
Thread-Index: AQHMNmgMwfCxr4U7Fk+rVh73SqICZ5TWxREA//+SDcCAAT+kgP//1hMg
Date: Fri, 1 Jul 2011 12:48:44 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480816C44C@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-34-git-send-email-kys@microsoft.com>
 <20110630194530.GE22707@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480816C297@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110701081601.GB28322@infradead.org>
In-Reply-To: <20110701081601.GB28322@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, July 01, 2011 4:16 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD); Hank Janssen
> Subject: Re: [PATCH 34/40] Staging: hv: storvsc: Add the contents of
> hyperv_storage.h to storvsc_drv.c
> 
> On Thu, Jun 30, 2011 at 08:13:51PM +0000, KY Srinivasan wrote:
> > > > Add the contents of hyperv_storage.h to storvsc_drv.c and cleanup
> > > storvsc_drv.c.n
> > >
> > > I'd at least leave the first half of the header that defines the
> > > protocol around.
> >
> > I only got rid of the block comment at the start of hyperv_storage.h
> > and consolidated the include files. Nothing of substance was deleted.
> 
> I meant to say keeping a separate header file for the protocol defintion
> might be a good idea.  That way it is kept separate from the
> implementation details
> 
Ok; I get it. Although, a while ago as I was cleaning up the header files
In preparation to exiting staging, Greg had indicated that each driver
should, if possible be a single file. I merged the relevant files to comply
with that directive. 

Regards,

K. Y
