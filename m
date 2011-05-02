Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab1EBVQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:16:39 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:41413 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab1EBVQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:16:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Topic: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Index: AQHMBGnbOdiUysHbTUGr026Sn7cwwZRw2pzQgADfZgD//9dIkIAAhckAgALsDiCAAIGrgIADE/mA//+K1cCAAHyegP//qoFAABSsIIAAII/J0AAP4IMAAAwOQRA=
Date: Mon, 2 May 2011 21:16:36 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DF56D@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427121856.GA20633@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD676@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110429164025.GA7698@kroah.com> <20110501154041.GB15210@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DF253@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110501160721.GA8195@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DF2A0@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110501205315.GC1017@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DF543@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110502200012.GA21619@infradead.org>
In-Reply-To: <20110502200012.GA21619@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, May 02, 2011 4:00 PM
> To: KY Srinivasan
> Cc: Christoph Hellwig; Greg KH; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
> 
> On Mon, May 02, 2011 at 07:48:38PM +0000, KY Srinivasan wrote:
> > By setting up appropriate modprobe rules, this can be addressed.
> 
> That assumes libata is a module, which it is not for many popular
> distributions.
> 
As long as you can prevent ata_piix from loading, it should be fine.

Regards,

K. Y
