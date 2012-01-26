Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2AZRsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:48:04 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:10618
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab2AZRsC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:48:02 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz9371I542M154dM1432N98dKzz1202hzz8275bh8275dhz2fhc1bhc31hc1ah2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/2] Staging: hv: Applied all the patches already in the
 staging queue
Thread-Topic: [PATCH 1/2] Staging: hv: Applied all the patches already in
 the staging queue
Thread-Index: AQHM3FDeCPcI7MXkNkGSexSU4QdONpYfb+6A//96DmA=
Date: Thu, 26 Jan 2012 17:41:05 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B6FE650@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
 <1327599515-12679-1-git-send-email-kys@microsoft.com>
 <20120126173751.GA14400@suse.de>
In-Reply-To: <20120126173751.GA14400@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Thursday, January 26, 2012 12:38 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the staging
> queue
> 
> On Thu, Jan 26, 2012 at 09:38:34AM -0800, K. Y. Srinivasan wrote:
> > This patch gets the storage driver to the same level as in the staging tree.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/staging/hv/storvsc_drv.c | 1301 ++++++++++++++++++-------------------
> >  1 files changed, 633 insertions(+), 668 deletions(-)
> 
> What?  That changelog comment makes no sense at all, as you are patching
> the staging version of the driver.  This isn't an acceptable patch at
> all.
> 
> Yes, I have pending patches for this driver in my "to-apply" queue, but
> that is for 3.4, not now.

If you prefer; we could move the storage driver out of staging, based on the code
We have in staging. I could re-submit the patches against the new location for
3.4.

Regards,

K. Y

