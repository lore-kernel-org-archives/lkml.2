Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2BIPcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:32:14 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:44914
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751215Ab2BIPcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:32:12 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzz8275dhz2fh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/2] Staging: hv: Applied all the patches already in the
 staging queue
Thread-Topic: [PATCH 1/2] Staging: hv: Applied all the patches already in
 the staging queue
Thread-Index: AQHM3FDeCPcI7MXkNkGSexSU4QdONpYfb+6AgAADmQCAFVK60A==
Date: Thu, 9 Feb 2012 15:31:50 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B70C8A1@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
	 <1327599515-12679-1-git-send-email-kys@microsoft.com>
	 <20120126173751.GA14400@suse.de>
 <1327600244.6151.5.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1327600244.6151.5.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q19FWN18011365



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thursday, January 26, 2012 12:51 PM
> To: Greg KH
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the staging
> queue
> 
> > Yes, I have pending patches for this driver in my "to-apply" queue, but
> > that is for 3.4, not now.
> >
> > So, how about I just apply those patches, and then apply a patch that
> > moves it out of staging into drivers/scsi/, and queue all of those up
> > for 3.4.
> >
> > James, any objection to that?
> 
> Well, we were going to try to stage this driver for 3.3-rc.  If everyone
> agrees to push it back to 3.4, then this works for me.

Greg,

Now that you have applied all the pending patches for the Hyper-V storage
driver; do you want me to resend the patch that moved this driver out of staging?

Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
