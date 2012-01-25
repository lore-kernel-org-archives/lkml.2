Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2AYRMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 12:12:14 -0500
Received: from mx2.parallels.com ([64.131.90.16]:34998 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab2AYRMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:12:13 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Greg KH <gregkh@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Index: AQHM0W763o2pXZK11UadxuudCK0AbpYMmkCA//+5EwCAA1dLgIANnEvAgACMXQCAAAJOgIAAAkoAgAAR/4CAAAJNgA==
Date: Wed, 25 Jan 2012 17:12:05 +0000
Message-ID: <1327511525.2776.40.camel@dabdike.int.hansenpartnership.com>
References: <1326402943-14031-1-git-send-email-kys@microsoft.com>
	 <20120114164228.GB9682@infradead.org>
	 <6E21E5352C11B742B20C142EB499E0481B6F0307@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <20120116152951.GA9720@infradead.org>
	 <6E21E5352C11B742B20C142EB499E0481B6FE0E2@TK5EX14MBXC122.redmond.corp.microsoft.com>
	 <20120125154300.GA19509@infradead.org> <20120125155115.GA3608@suse.de>
	 <1327507166.2776.32.camel@dabdike.int.hansenpartnership.com>
	 <20120125170351.GB5461@suse.de>
In-Reply-To: <20120125170351.GB5461@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <247CCA2CE3283C44807740385FC21995@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0PHCU6L005198

On Wed, 2012-01-25 at 09:03 -0800, Greg KH wrote:
> On Wed, Jan 25, 2012 at 03:59:26PM +0000, James Bottomley wrote:
> > On Wed, 2012-01-25 at 07:51 -0800, Greg KH wrote:
> > > On Wed, Jan 25, 2012 at 10:43:00AM -0500, Christoph Hellwig wrote:
> > > > On Wed, Jan 25, 2012 at 03:29:05PM +0000, KY Srinivasan wrote:
> > > > > James,
> > > > > Any updates here? 
> > > > 
> > > > Given that this is a new driver without external dependencies it seems
> > > > fine even for a 3.3 merge to me.
> > > 
> > > Fine with me as well.
> > 
> > OK, so what I need to linux-scsi is an applyable patch moving it out of
> > staging.
> 
> I think there have been about 3-4 copies of this in your email archives,
> but if that didn't work, I'm sure that KY can create it again :)

Actually, no ... I've got a patch adding it to staging.  What I need to
add it in -rc is the motion piece (remove from staging and add to SCSI)
so that git doesn't say I'm trying to add 1600 lines during rc but am
just quietly moving a file ...

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
