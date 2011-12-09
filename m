Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1LIO5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:57:13 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:59099 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754330Ab1LIO5J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:57:09 -0500
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>,
        "James Bottomley" <jejb@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 9 Dec 2011 20:26:57 +0530
Subject: RE: mpt2sas regression: can not add disk...
Thread-Topic: mpt2sas regression: can not add disk...
Thread-Index: Acy17byRphK0xIxTQuCXmq8Yfm8csQAlOoBQ
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70D912FF9DE@inbmail01.lsi.com>
References: <7863850E8C98C748980632D9D3B7C19911968B8AE5@inbmail02.lsi.com>
	<A6888A6805518E4EA4AF7072A28264A604726F2824@inbmail02.lsi.com>
	<CAE9FiQWY-jhtbCmdfBY1zg_d0nreTHbkVe3CmaPQMgojDAtLaw@mail.gmail.com>
	<CAE9FiQXbu-O2exdhjziWCdiWWGNb8q7_RoECeKC5K80DEOobbw@mail.gmail.com>
	<B2FD678A64EAAD45B089B123FDFC3ED70D912FF83D@inbmail01.lsi.com>
	<B2FD678A64EAAD45B089B123FDFC3ED70D912FF8E3@inbmail01.lsi.com>
 <CAE9FiQUBkjfOYrjxAVxG7F3GF11trkOnf0ZoKS4h5Db2gQJvbA@mail.gmail.com>
In-Reply-To: <CAE9FiQUBkjfOYrjxAVxG7F3GF11trkOnf0ZoKS4h5Db2gQJvbA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Friday, December 09, 2011 2:40 AM
> To: Desai, Kashyap
> Cc: Nandigama, Nagalakshmi; James Bottomley; Rafael J. Wysocki; linux-
> scsi-owner@vger.kernel.org; James Bottomley; linux-scsi@vger.kernel.org;
> Linux Kernel Mailing List
> Subject: Re: mpt2sas regression: can not add disk...
> 
> On Thu, Dec 8, 2011 at 5:30 AM, Desai, Kashyap <Kashyap.Desai@lsi.com>
> wrote:
> > Yinghai,
> >
> > Please try attached patch. This must be on top of latest upstream
> code.
> > When we have introduced fast load, scan of devices are happening from
> thread context.
> >
> > But currently we have not removed " _scsih_probe_devices(ioc);" call
> from actual probe and it is getting called from multiple places.
> > As a result, we end-up into this issue.
> >
> > Please try the attached patch and provide your feedback. Based upon
> your result, we will post this patch to upstream.
> 
> Yes.  The attaced patch fix the problem. the disk that is attached to
> the mpt2sas card is showing up in OS.

Thanks for the test report. LSI will post this patch to upstream. 

` Kashyap

> 
> Thanks
> 
> Yinghai Lu
