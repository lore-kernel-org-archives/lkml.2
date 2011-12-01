Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1LAVNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:13:40 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:58102
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874Ab1LAVNi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:13:38 -0500
X-SpamScore: -22
X-BigFish: VS-22(zz9371K542M154dM1432N98dKzz1202hzzz2fh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 4/5] Staging: hv: storvsc: Fix a bug in
 copy_from_bounce_buffer()
Thread-Topic: [PATCH 4/5] Staging: hv: storvsc: Fix a bug in
 copy_from_bounce_buffer()
Thread-Index: AQHMsCkKHUy0MoNgQ0qgyL64yE+Z5JXH/wYA//96smCAAIe+AP//efng
Date: Thu, 1 Dec 2011 21:13:34 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA7B529@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1322744315-13017-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-4-git-send-email-kys@microsoft.com>
 <20111201210304.GY3195@mwanda>
 <6E21E5352C11B742B20C142EB499E0481AA7B4EF@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20111201211147.GL20466@mwanda>
In-Reply-To: <20111201211147.GL20466@mwanda>
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
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, December 01, 2011 4:12 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> James.Bottomley@HansenPartnership.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; Haiyang Zhang
> Subject: Re: [PATCH 4/5] Staging: hv: storvsc: Fix a bug in
> copy_from_bounce_buffer()
> 
> On Thu, Dec 01, 2011 at 09:07:46PM +0000, KY Srinivasan wrote:
> > Sorry Dan. I put in some comments in the code describing the bug. Perhaps I
> > should have copied that in the changelog as well.
> 
> Yes.  That's the entire point of the changelog, in fact.  Could you
> fix it and resend?

I could do that, but Greg has already checked in this patch. 

Regards,

K. Y

