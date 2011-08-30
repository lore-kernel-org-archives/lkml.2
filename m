Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab1H3RZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:25:28 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:14858 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab1H3RZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:25:25 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>, Dan Carpenter <error27@gmail.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling
 in vmbus_bus_init()
Thread-Topic: [PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling
 in vmbus_bus_init()
Thread-Index: AQHMZOS1xsL7F2lXdkukWoVslPXxw5U0mO0AgAESH4CAADzMgP//weNQ
Date: Tue, 30 Aug 2011 17:25:23 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B537B@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-41-git-send-email-kys@microsoft.com>
 <20110829180842.GA23618@kroah.com> <20110830102949.GD3705@shale.localdomain>
 <20110830140725.GA16570@kroah.com>
In-Reply-To: <20110830140725.GA16570@kroah.com>
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
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, August 30, 2011 10:07 AM
> To: Dan Carpenter
> Cc: KY Srinivasan; devel@linuxdriverproject.org; Haiyang Zhang; gregkh@suse.de;
> linux-kernel@vger.kernel.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling in
> vmbus_bus_init()
> 
> On Tue, Aug 30, 2011 at 01:29:49PM +0300, Dan Carpenter wrote:
> > > err3:
> > > 	free_irq(irq, hv_acpi_dev);
> > > err2:
> > > 	bus_unregister(&hv_bus);
> > > err1:
> > > 	hv_cleanup();
> >
> > Also here is an oldbie trick.  You could use multiples of ten like
> > err30, err20, and err10.  That way if you can add more error handling
> > in the middle without changing the numbering.  I knew my GW-BASIC
> > experience would come in handy one day.  :)
> >
> > The better way to label things is based on what happens when you get
> > there: err_irq, err_unregister, err_cleanup.
> 
> Yes, that's the best way to do this, thanks for pointing it out.

I will fix this up.

Regards,

K. Y
> 
> greg k-h

