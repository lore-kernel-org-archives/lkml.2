Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab2AYP31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:29:27 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:6666
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab2AYP30 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:29:26 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275bhz2fhc1bhc31hc1ah2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Index: AQHM0W763o2pXZK11UadxuudCK0AbpYMmkCA//+5EwCAA1dLgIANnEvA
Date: Wed, 25 Jan 2012 15:29:05 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B6FE0E2@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1326402943-14031-1-git-send-email-kys@microsoft.com>
 <20120114164228.GB9682@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481B6F0307@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20120116152951.GA9720@infradead.org>
In-Reply-To: <20120116152951.GA9720@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, January 16, 2012 10:30 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; JBottomley@parallels.com; gregkh@suse.de; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com
> Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> staging area
> 
> On Sat, Jan 14, 2012 at 08:31:18PM +0000, KY Srinivasan wrote:
> > Thanks Christoph. Would you be taking this driver out of staging or should I ask
> Greg. James had indicated that
> > he had turned the driver over to you for reviewing.
> 
> In the end James still maintains the SCSI tree and send on all drivers.
> The only thing I can do is give a positive review.
James,
Any updates here? 

Regards,

K. Y

