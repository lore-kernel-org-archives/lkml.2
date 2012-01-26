Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2AZOLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:11:47 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:17084
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab2AZOLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:11:45 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371I936eK542M1432N98dKzz1202hzz8275bhz2fhc1bhc31hc1ah2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>, Greg KH <gregkh@suse.de>
CC: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Index: AQHM0W763o2pXZK11UadxuudCK0AbpYMmkCA//+5EwCAA1dLgIANnEvAgACMXQCAAAJOgIAAAkoAgAAR/4CAAAJNgIAAU15A
Date: Thu, 26 Jan 2012 14:11:20 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B6FE5C1@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1326402943-14031-1-git-send-email-kys@microsoft.com>
	 <20120114164228.GB9682@infradead.org>
	 <6E21E5352C11B742B20C142EB499E0481B6F0307@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <20120116152951.GA9720@infradead.org>
	 <6E21E5352C11B742B20C142EB499E0481B6FE0E2@TK5EX14MBXC122.redmond.corp.microsoft.com>
	 <20120125154300.GA19509@infradead.org> <20120125155115.GA3608@suse.de>
	 <1327507166.2776.32.camel@dabdike.int.hansenpartnership.com>
	 <20120125170351.GB5461@suse.de>
 <1327511525.2776.40.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1327511525.2776.40.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0QEBo2X011250



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Wednesday, January 25, 2012 12:12 PM
> To: Greg KH
> Cc: Christoph Hellwig; KY Srinivasan; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com
> Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> staging area
> 
> On Wed, 2012-01-25 at 09:03 -0800, Greg KH wrote:
> > On Wed, Jan 25, 2012 at 03:59:26PM +0000, James Bottomley wrote:
> > > On Wed, 2012-01-25 at 07:51 -0800, Greg KH wrote:
> > > > On Wed, Jan 25, 2012 at 10:43:00AM -0500, Christoph Hellwig wrote:
> > > > > On Wed, Jan 25, 2012 at 03:29:05PM +0000, KY Srinivasan wrote:
> > > > > > James,
> > > > > > Any updates here?
> > > > >
> > > > > Given that this is a new driver without external dependencies it seems
> > > > > fine even for a 3.3 merge to me.
> > > >
> > > > Fine with me as well.
> > >
> > > OK, so what I need to linux-scsi is an applyable patch moving it out of
> > > staging.
> >
> > I think there have been about 3-4 copies of this in your email archives,
> > but if that didn't work, I'm sure that KY can create it again :)
> 
> Actually, no ... I've got a patch adding it to staging.  What I need to
> add it in -rc is the motion piece (remove from staging and add to SCSI)
> so that git doesn't say I'm trying to add 1600 lines during rc but am
> just quietly moving a file ...

Given that the final set of patches that addressed Christoph's comments were against
Greg's staging tree and the patch I sent  that moves this driver from
staging to the scsi directory is also against the staging tree, would it make sense to
take this driver through Greg's staging tree; assuming it is ok with both James and Greg. 

Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
