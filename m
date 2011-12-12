Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1LLXuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:50:52 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:19230 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1LLXur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:50:47 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275bhz2fh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>
Subject: RE: [PATCH 0000/0004] Drivers: hv: Fixes
Thread-Topic: [PATCH 0000/0004] Drivers: hv: Fixes
Thread-Index: AQHMuR3eJNDtMgmXLEuW8HXGtO7nyJXY3dMA
Date: Mon, 12 Dec 2011 23:50:44 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AD80006@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1323710931-29616-1-git-send-email-kys@microsoft.com>
 <20111212222801.GA16054@kroah.com>
In-Reply-To: <20111212222801.GA16054@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, December 12, 2011 5:28 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com
> Subject: Re: [PATCH 0000/0004] Drivers: hv: Fixes
> 
> On Mon, Dec 12, 2011 at 09:28:51AM -0800, K. Y. Srinivasan wrote:
> > Some fixes to the vmbus driver:
> >
> > 	1. Fix a memory leak in a failure path.
> >
> > 	2. Make vmbus driver unloadable.
> >
> > 	3. Get rid of an unnecessary check in hv_init()
> > 	   in preparation for supporting kexec().
> >
> > 	4. Make it possible to build the vmbus driver as part of the
> > 	   kernel. This patch was submitted earlier, but seems to have been
> > 	   lost.
> 
> No, it was not lost, it was applied to my driver-core-next tree a while
> ago.  Because of this, I had to hand-edit patch 2 above and skip patch 4
> here.

Thanks Greg. I will check to see why I got some stale bits yesterday.

Regards,

K. Y


