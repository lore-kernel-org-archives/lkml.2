Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab1FGVj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:39:58 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:53578 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1FGVj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:39:57 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 49/49] Staging: hv: vmbus: Increase the timeout value in
 vmbus_request_offers()
Thread-Topic: [PATCH 49/49] Staging: hv: vmbus: Increase the timeout value
 in vmbus_request_offers()
Thread-Index: AQHMJJo9r2uLXlggOECLS9ST8ZfGt5Sy074A//+RXpCAAHqVAP//jcZw
Date: Tue, 7 Jun 2011 21:39:52 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480813DCA5@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-49-git-send-email-kys@microsoft.com>
 <20110607204514.GB16429@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480813DC6F@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20110607212800.GA3331@suse.de>
In-Reply-To: <20110607212800.GA3331@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, June 07, 2011 5:28 PM
> To: KY Srinivasan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Abhishek Kane (Mindtree Consulting
> PVT LTD)
> Subject: Re: [PATCH 49/49] Staging: hv: vmbus: Increase the timeout value in
> vmbus_request_offers()
> 
> On Tue, Jun 07, 2011 at 09:20:16PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Tuesday, June 07, 2011 4:45 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > > Abhishek Kane (Mindtree Consulting PVT LTD)
> > > Subject: Re: [PATCH 49/49] Staging: hv: vmbus: Increase the timeout value in
> > > vmbus_request_offers()
> > >
> > > On Mon, Jun 06, 2011 at 03:50:13PM -0700, K. Y. Srinivasan wrote:
> > > > Increase the timeout value in vmbus_request_offers().
> > >
> > > Why?  What does this solve/fix/prevent?
> >
> > On some very loaded systems, when we tested the 1 second timeout that
> > we had prior to this patch was insufficient. So I bumped it to 5 seconds.
> 
> Ok, then this should be something that goes into 3.0 and older kernels,
> right?
> 
> If so, please say so, with this type of description, when you submit it.
> 
> Remember, don't say only what you did in the changelog comment, but why
> you did it if it's not obvious (and it wasn't here.)
> 
> Care to resend this one with this information?

Will do.

Thanks,

K. Y

