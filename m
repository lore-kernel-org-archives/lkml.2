Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1LAQwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:52:41 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:14268
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755407Ab1LAQwj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:52:39 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz9371K1102K542M1432N98dKzz1202hzz8275dhz2fh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Sasha Levin <levinsasha928@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv: Don't OOPS when can't init vmbus
Thread-Topic: [PATCH] hv: Don't OOPS when can't init vmbus
Thread-Index: AQHMp+eh4zIBCWhb0U2Luaw05fid05W2hGmwgAD3xYCAEDiDAP//etUwgACH/ID//3w5kIAAjOQA//+By4A=
Date: Thu, 1 Dec 2011 16:52:10 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA7B2E6@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1321836494-4624-1-git-send-email-levinsasha928@gmail.com>
 <6E21E5352C11B742B20C142EB499E0481AA70B8E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <1321862131.3231.16.camel@lappy> <1322753876.6040.1.camel@lappy>
 <6E21E5352C11B742B20C142EB499E0481AA7B272@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20111201154801.GA7130@suse.de>
 <6E21E5352C11B742B20C142EB499E0481AA7B28F@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20111201162038.GA6040@suse.de>
In-Reply-To: <20111201162038.GA6040@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Thursday, December 01, 2011 11:21 AM
> To: KY Srinivasan
> Cc: Sasha Levin; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] hv: Don't OOPS when can't init vmbus
> 
> On Thu, Dec 01, 2011 at 03:58:10PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@suse.de]
> > > Sent: Thursday, December 01, 2011 10:48 AM
> > > To: KY Srinivasan
> > > Cc: Sasha Levin; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH] hv: Don't OOPS when can't init vmbus
> > >
> > > On Thu, Dec 01, 2011 at 03:42:43PM +0000, KY Srinivasan wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Sasha Levin [mailto:levinsasha928@gmail.com]
> > > > > Sent: Thursday, December 01, 2011 10:38 AM
> > > > > To: KY Srinivasan
> > > > > Cc: linux-kernel@vger.kernel.org; Greg Kroah-Hartman
> > > > > Subject: RE: [PATCH] hv: Don't OOPS when can't init vmbus
> > > > >
> > > > > Ping? Did it go anywhere?
> > > >
> > > > I think I acked it; if not I am acking it now. I don't know if
> > > > Greg dropped this patch.
> > >
> > > I did as I thought you said you would take care of it.
> > >
> > > KY, can you please resend it with your ack?
> >
> > Sasha,
> >
> > Do you want to resend the patch to Greg with my ack.
> 
> Um, the maintainers job (i.e. you) is to collect stuff like this and
> push it upstream (i.e. to me), is this not going to be possible for some
> reason with this, and future patches?

Ok; I was not sure of the workflow here.  I will send you the patch shortly.
Sorry for the confusion.

Regards,

K. Y


