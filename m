Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1GIXsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 19:48:20 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:36690 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab1GIXsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 19:48:16 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
Date: Sun, 10 Jul 2011 01:48:10 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-amd64; KDE/4.6.3; x86_64; ; )
Cc: Daniel Drake <dsd@laptop.org>, Andres Salomon <dilinger@queued.net>,
        Dan Williams <dcbw@redhat.com>, cjb@laptop.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <20110618213803.521db1b3@debxo> <BANLkTi=CPEmFVbwuSBSsQjv4ZqHX+Ng8gw@mail.gmail.com> <BANLkTin00W9f40PUjbjgYVRydU7ttJFr9A@mail.gmail.com>
In-Reply-To: <BANLkTin00W9f40PUjbjgYVRydU7ttJFr9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107100148.10723.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 23, 2011 03:42:17 PM Daniel Drake wrote:
> On 21 June 2011 09:05, Daniel Drake <dsd@laptop.org> wrote:
> > The other changes look fine, and we will figure out sd8686 and send a
> > later pull request for that. Dan, can you send over
> > SD-8686-FEDORA26FC6-SYSKT-9.70.20.p0-26409.p64, and any release
> > notes/changelog you may have? I wasn't aware of this release.
> 
> Also, could you take a look and see if there is some kind of archived
> changelog or release history that would link the 3 firmware versions
> in question to the same release stream? If it seems obvious that one
> follows on from the other it would avoid me having to pester Marvell
> about this.
> 
> The 3 versions in question are:
> 
> 1. The version in linux-firmware
> $Id: sd8686-B0, RF868X, FP4, 9.70.3.p36 $
> RC: , yhou, 2008/09/08, 19:11:06
> md5sum: 20208583d441d1ecd7a05d5e5cda5856
> 
> 2. The OLPC version, shipped in Fedora:
> $Id: sd8686-B0, RF868X, FP4, 9.70.7.p0 $
> RC: , yhou, 2008/11/11, 13:10:01
> md5sum: b4f8be61e19780a14836f146c538c5dd
> 
> 3. The latest version that you've found
> SD-8686-FEDORA26FC6-SYSKT-9.70.20.p0-26409.p64

Maybe someone can add firmware for CF8381 from here 
http://www.hackchina.com/en/cont/36429 . I dunno how legal it'd be though. I 
discussed it with Marvell folks (that someone apparently leaked such thing) and 
they didn't even seem too interested. :-/

> 
> Thanks,
> Daniel
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
