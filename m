Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0GITC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:02:29 -0400
Received: from chip2og120.obsmtp.com ([64.18.13.89]:40671 "HELO
	chip2og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753467Ab0GITC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:02:27 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2010 15:02:27 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: nic enumeration
Date: Fri, 9 Jul 2010 14:55:16 -0400
Message-ID: <D3F292ADF945FB49B35E96C94C2061B90C3CF510@nsmail.netscout.com>
In-Reply-To: <20100709171529.GA27241@auslistsprd01.us.dell.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nic enumeration
Thread-Index: Acsfila9gYFls+alSLahI6iJ2LlMnQABC/lw
References: <82tyo9i0n2.fsf@mid.bfk.de> <D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com> <20100709171529.GA27241@auslistsprd01.us.dell.com>
From: "Loke, Chetan" <Chetan.Loke@netscout.com>
To: "Matt Domsch" <Matt_Domsch@dell.com>
Cc: "Florian Weimer" <fweimer@bfk.de>, <linux-net@vger.kernel.org>,
       "Michael Di Domenico" <mdidomenico4@gmail.com>,
       <linux-kernel@vger.kernel.org>, <kay.sievers@vrfy.org>
X-OriginalArrivalTime: 09 Jul 2010 18:55:17.0994 (UTC) FILETIME=[45FDC4A0:01CB1F98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Matt Domsch [mailto:Matt_Domsch@dell.com]
> Sent: July 09, 2010 1:15 PM
> To: Loke, Chetan
> Cc: Florian Weimer; linux-net@vger.kernel.org; Michael Di Domenico;
> linux-kernel@vger.kernel.org; kay.sievers@vrfy.org
> Subject: Re: nic enumeration
> 
> On Fri, Jul 09, 2010 at 12:27:53PM -0400, Loke, Chetan wrote:
> > Ok, no renaming, I would like a reference. And symlink just doesn't
> work
> > w/ the udevadm trigger business. We've tried that already.
> >
> > What needs to be changed in udev etc to create a soft link? Any
place
> > where I should start digging and gotchas to lookout for?
> 
> Unlike disks which have /dev/disk/by-{id,path,uuid}/* symlinks back to
> /dev/sd*, which udev manages, network devices have no such on-disk
> representation for udev to manage.  My proposal to create such on-disk
> mappings was shot down, as was my suggestion to create (multiple)
> network device symlinks/references/aliases inside the kernel.
> 

Ok, I'm reading your link below/libnetdevname and original patch too.

I'm willing to bend over to get something done. It's so much better than
getting repeatedly tortured by customers.


> FWIW, I have a talk at LinuxCon Boston coming up on this, and have a
> proposal in for Linux Plumbers Conference as well.
> 
> Thanks,
> Matt
> 

Regards
Chetan Loke

