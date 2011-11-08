Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1KHQqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:46:17 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:3339 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1KHQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:46:13 -0500
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>
Subject: RE: [PATCH 0000/0011] Staging: hv: storvsc cleanup/new features
Thread-Topic: [PATCH 0000/0011] Staging: hv: storvsc cleanup/new features
Thread-Index: AQHMnjR+TERJChUpmEWXUGgElct2zpWjs6wA//96I0A=
Date: Tue, 8 Nov 2011 16:46:12 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA69CC7@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1320771677-29095-1-git-send-email-kys@microsoft.com>
 <1320770370.2883.10.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1320770370.2883.10.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.79]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pA8GkYUG021772



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Tuesday, November 08, 2011 11:40 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> hch@infradead.org
> Subject: Re: [PATCH 0000/0011] Staging: hv: storvsc cleanup/new features
> 
> On Tue, 2011-11-08 at 09:01 -0800, K. Y. Srinivasan wrote:
> > Cleanup storvsc based on review comments from James and
> > implement a couple of new features:
> >
> > 	1) The bulk of this patch-set addresses the review comments by James.
> > 	   James, the last time I had posted the patch to move the storage
> > 	   driver out of staging, you wanted to wait until Greg's tree had
> > 	   percolated up. Now, Greg's staging/hv has been merged up. Do you
> > 	   now want me to re-post the patch to move the storage driver
> > 	   out of staging? Let me know.
> >
> > 	2) I have also implemented the feature to support hot add/remove
> > 	   of devices configured under the scsi controller on the host.
> 
> If you want scsi review on this, it should go to the scsi list:
> 
> linux-scsi@vger.kernel.org

These patches are against Greg's current staging tree. 
I was planning to send the patch that would move this driver out of staging
(that would include the cleanup patches I just sent out) to the scsi list. I am going
to send it out shortly.

Regards,

K. Y



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
