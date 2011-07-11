Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab1GKXzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 19:55:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab1GKXzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 19:55:38 -0400
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
From: Dan Williams <dcbw@redhat.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Daniel Drake <dsd@laptop.org>, libertas-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        cjb@laptop.org, David Woodhouse <dwmw2@infradead.org>
Date: Mon, 11 Jul 2011 18:59:07 -0500
In-Reply-To: <1310427457.3122.8.camel@dcbw.foobar.com>
References: <20110618213803.521db1b3@debxo>
	 <BANLkTin00W9f40PUjbjgYVRydU7ttJFr9A@mail.gmail.com>
	 <201107100148.10723.marek.vasut@gmail.com>
	 <201107100150.01166.marek.vasut@gmail.com>
	 <1310427457.3122.8.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1310428748.3122.10.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 18:37 -0500, Dan Williams wrote:
> On Sun, 2011-07-10 at 01:50 +0200, Marek Vasut wrote:
> > On Sunday, July 10, 2011 01:48:10 AM Marek Vasut wrote:
> > > On Thursday, June 23, 2011 03:42:17 PM Daniel Drake wrote:
> > > > On 21 June 2011 09:05, Daniel Drake <dsd@laptop.org> wrote:
> > > > > The other changes look fine, and we will figure out sd8686 and send a
> > > > > later pull request for that. Dan, can you send over
> > > > > SD-8686-FEDORA26FC6-SYSKT-9.70.20.p0-26409.p64, and any release
> > > > > notes/changelog you may have? I wasn't aware of this release.
> > > > 
> > > > Also, could you take a look and see if there is some kind of archived
> > > > changelog or release history that would link the 3 firmware versions
> > > > in question to the same release stream? If it seems obvious that one
> > > > follows on from the other it would avoid me having to pester Marvell
> > > > about this.
> > > > 
> > > > The 3 versions in question are:
> > > > 
> > > > 1. The version in linux-firmware
> > > > $Id: sd8686-B0, RF868X, FP4, 9.70.3.p36 $
> > > > RC: , yhou, 2008/09/08, 19:11:06
> > > > md5sum: 20208583d441d1ecd7a05d5e5cda5856
> > > > 
> > > > 2. The OLPC version, shipped in Fedora:
> > > > $Id: sd8686-B0, RF868X, FP4, 9.70.7.p0 $
> > > > RC: , yhou, 2008/11/11, 13:10:01
> > > > md5sum: b4f8be61e19780a14836f146c538c5dd
> > > > 
> > > > 3. The latest version that you've found
> > > > SD-8686-FEDORA26FC6-SYSKT-9.70.20.p0-26409.p64
> > > 
> > > Maybe someone can add firmware for CF8381 from here
> > > http://www.hackchina.com/en/cont/36429 . I dunno how legal it'd be though.
> > > I discussed it with Marvell folks (that someone apparently leaked such
> > > thing) and they didn't even seem too interested. :-/
> > 
> > (if I converted cf8381.h and helper.h, it works with CF8381 in my PalmTX)
> 
> What version is that firmware?  I can legitimately push
> cf8381_B0_W8015FP1 version 5.11.9.p0 (dated 2006-05-15) into
> linux-firmware.

Until the firmware gets pulled, please see:

http://cgit.freedesktop.org/~dcbw/linux-firmware/commit/?id=84be6f96075541a96ca6c9d2b736f6a03f47b0a5

and let me know if that helper & image work with your hardware.
Assuming your hardware has an 8015RF of course.

Dan

> Dan
> 
> > > 
> > > > Thanks,
> > > > Daniel
> > > > 
> > > > _______________________________________________
> > > > libertas-dev mailing list
> > > > libertas-dev@lists.infradead.org
> > > > http://lists.infradead.org/mailman/listinfo/libertas-dev
> 
> 
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev


