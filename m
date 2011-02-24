Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1BXN4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:56:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48357 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1BXN4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:56:17 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Sergei Shtylyov <sshtylyov@mvista.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 24 Feb 2011 19:25:51 +0530
Subject: RE: [PATCH v3 1/2] PRUSS UIO driver support
Thread-Topic: [PATCH v3 1/2] PRUSS UIO driver support
Thread-Index: AcvTm+Ds8HuQnCOgRUq5QOs7r/r8BQAjpgaw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BE49815@dbde02.ent.ti.com>
References: <1298469161-7644-1-git-send-email-pratheesh@ti.com>
 <1298469161-7644-2-git-send-email-pratheesh@ti.com>
 <alpine.LFD.2.00.1102232057260.2701@localhost6.localdomain6>
 <4D6572ED.9020805@mvista.com>
 <alpine.LFD.2.00.1102232153500.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102232153500.2701@localhost6.localdomain6>
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
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Thursday, February 24, 2011 2:24 AM
> To: Sergei Shtylyov
> Cc: TK, Pratheesh Gangadhar; davinci-linux-open-
> source@linux.davincidsp.com; Chatterjee, Amit; gregkh@suse.de; linux-
> kernel@vger.kernel.org; hjk@hansjkoch.de; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v3 1/2] PRUSS UIO driver support
> 
> On Wed, 23 Feb 2011, Sergei Shtylyov wrote:
> > Hello.
> >
> > On 23-02-2011 23:25, Thomas Gleixner wrote:
> >
> > > > +	prussio_virt_addr =
> > > > +	    ioremap(regs_prussio->start,
> > > > +		    regs_prussio->end - regs_prussio->start + 1);
> >
> > > Either make those variable names shorter or do:
> >
> > >         len = regs_prussio->end - regs_prussio->start + 1;
> >
> >    Or even:
> >
> > 	len = resource_size(regs_prussio);
> >
> > >         prussio_virt_addr = ioremap(regs_prussio->start, len);
> 
> Good point. Forgot about that one :)
> 
Thanks will do this.

Pratheesh
