Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab1EAPq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:46:27 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:26011 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1EAPqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:46:24 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Topic: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Index: AQHMBGnbOdiUysHbTUGr026Sn7cwwZRw2pzQgADfZgD//9dIkIAAhckAgALsDiCAAIGrgIADE/mA//+K1cA=
Date: Sun, 1 May 2011 15:46:23 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DF253@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427064550.GA597@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427121856.GA20633@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD676@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110429164025.GA7698@kroah.com> <20110501154041.GB15210@infradead.org>
In-Reply-To: <20110501154041.GB15210@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, May 01, 2011 11:41 AM
> To: Greg KH
> Cc: KY Srinivasan; Christoph Hellwig; gregkh@suse.de; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
> 
> On Fri, Apr 29, 2011 at 09:40:25AM -0700, Greg KH wrote:
> > Are you sure the libata core can't see this ide controller and connect
> > to it?  That way you would use the scsi system if you do that and you
> > would need a much smaller ide driver, perhaps being able to merge it
> > with your scsi driver.
> >
> > We really don't want to write new IDE drivers anymore that don't use
> > libata.
> 
> The blkvsc driver isn't an IDE driver, although it currently claims
> the old IDE drivers major numbers, which is a no-no and can't work
> in most usual setups.

What is the issue here? This is no different than what is done in other
Virtualization platforms. For instance, the Xen blkfront driver is no
different - if you specify the block device to be presented to the guest
as an ide device, it will register for the appropriate ide major number.

Regards,

K. Y 

> I'm pretty sure I already complained about
> this in a previous review round.


