Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1HXBBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:01:32 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:24649 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab1HXBB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:01:27 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 0000/0117] Staging: hv: Driver cleanup
Thread-Topic: [PATCH 0000/0117] Staging: hv: Driver cleanup
Thread-Index: AQHMQxS9effZMHZjokC/XwNaRWC5F5Urwx4A//+os6A=
Date: Wed, 24 Aug 2011 01:01:26 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B23B1@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <20110823231120.GP9641@kroah.com>
In-Reply-To: <20110823231120.GP9641@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, August 23, 2011 7:11 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 0000/0117] Staging: hv: Driver cleanup
> 
> On Fri, Jul 15, 2011 at 10:47:04AM -0700, K. Y. Srinivasan wrote:
> > Further cleanup of the hv drivers. Back in June I had sent two patch
> > sets to address these issues. I have addressed the comments I got from
> > the community on my earlier patches here:
> >
> > 	1) Implement code for autoloading the vmbus drivers without using PCI
> or DMI
> > 	   signatures. I have implemented this based on Greg's feedback on my
> earlier
> > 	   implementation.
> >
> > 	2) Cleanup error handling across the board and use standard Linux error
> codes.
> >
> > 	3) General cleanup
> >
> > 	4) Some bug fixes.
> >
> > 	5) Cleanup the reference counting mess for both stor and net devices.
> >
> > 	6) Handle all block devices using the storvsc driver. I have modified
> > 	   the implementation here based on Christoph's feedback on my earlier
> > 	   implementation.
> >
> > 	7) Accomodate some host side scsi emulation bugs.
> >
> > 	8) In case of scsi errors off-line the device.
> 
> Care to respin this patch series based on my comments?

Greg,

Thank you for your comments. I will try to re-submit these patches as soon as I
possibly can. If I were to get these patches re-spun and sent to you in the next couple of 
days, can I still make this current merge window?

Regards,

K. Y
> 
> thanks,
> 
> greg k-h

