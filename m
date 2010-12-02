Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0LBGa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 01:30:26 -0500
Received: from tomasu.net ([64.85.170.234]:49428 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab0LBGaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 01:30:25 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Andre Tomt <andre@tomt.net>
Subject: Re: mvsas errors in 2.6.36
Date: Wed, 1 Dec 2010 23:29:54 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
References: <201010290650.32892.thomas@fjellstrom.ca> <201011170053.31174.thomas@fjellstrom.ca> <4CE3912E.6060904@tomt.net>
In-Reply-To: <4CE3912E.6060904@tomt.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012012329.54944.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 17, 2010, you wrote:
> On 11/17/2010 08:53 AM, Thomas Fjellstrom wrote:
> [snip]
> 
> > Still no fatal errors, but the problem is still happening regularly. It
> > causes a pause in disk io of a couple seconds at least. Really quite
> > annoying.
> >
> > One thing thats got me wondering, is could this be a power issue?
> > It almost seems like (from the messages) that a single drive (any drive)
> > is freaking out, and returning an error that probably shouldn't happen (no 
> > CHS 0?), which could mean the drive is underpowered and the firmware is 
> > flipping out. I'm not entirely sure. The system has a 750w decent quality
> > Antec power supply. The total power use of the system shouldn't come over 
> > half that (phenom II x4 810 cpu, gigabyte ma790fxtud5p mb, low profile 
> > nvidia 9400GS gpu, 8 sata hdds, 3 fans, etc). I'm mostly sure the 12v 
> > rails are spread out evenly, but I have yet to make absolutely sure.

Made absolute sure. I had been worrying that I was overloading one of the 
rails on the PSU, but it turns out that it isn't a multi 12v rail PSU after 
all. The box and advertising says it is, but the electronics inside all say 
its a single 12v rail device.

> [snip]
> 
> After the mvsas update in 2.6.35 this started happening to me as well;
> at least its better than the previous state - not working.. ;-) However,
> after rolling a new 2.6.35 with the following fix that is queued up for
> the upcoming 2.6.35 and 2.6.36 stable releases, they seem to have
> dissapeared - 3 days and counting.
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_pl
> ain;f=queue-2.6.33/libsas-fix-ncq-mixing-with-non-ncq.patch;h=b6d7c92094d95
> ad67a3b23c2e09c25d4fbd0f46b;hb=HEAD
> 
> The fix is queued up for the next 2.6.36 and 2.6.35 stable point-releases.

Ahah. I wonder how I missed that when I first read it. I'll have to give the 
stable .36 kernel a try. Thanks!


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
