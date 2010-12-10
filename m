Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0LJRzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:55:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab0LJRzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:55:07 -0500
Date: Fri, 10 Dec 2010 18:54:47 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Lukas Czerner <lczerner@redhat.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Greg KH <gregkh@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, sandeen@redhat.com, hch@infradead.org, axboe@kernel.dk
Subject: Re: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
In-Reply-To: <AANLkTinQ+3BAEac44-TkiKjG-A5FiYsnXtgpZHi3T=qj@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1012101852460.2813@dhcp-lab-213.englab.brq.redhat.com>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com> <20101209192050.GA26457@suse.de> <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca> <alpine.LFD.2.00.1012101427270.2813@dhcp-lab-213.englab.brq.redhat.com>
 <AANLkTinQ+3BAEac44-TkiKjG-A5FiYsnXtgpZHi3T=qj@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571108635-327484916-1292003692=:2813"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571108635-327484916-1292003692=:2813
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 10 Dec 2010, Kay Sievers wrote:

> On Fri, Dec 10, 2010 at 15:07, Lukas Czerner <lczerner@redhat.com> wrote:
> > On Thu, 9 Dec 2010, Andreas Dilger wrote:
> >
> >> On 2010-12-09, at 12:20, Greg KH wrote:
> >> > On Thu, Dec 09, 2010 at 04:25:35PM +0100, Lukas Czerner wrote:
> >> >> For a long time it has been pretty painful to retrieve informations from
> >> >> /sys/block/*/queue for particular block device. Not only it is painful
> >> >> to retrieve informations within C tool, parsing strings, etc, but one
> >> >> have to run into problem even finding the proper path in sysfs.
> >> >
> >> > What's wrong with using libudev?  That should give you all of this
> >> > information easily using a .c program without any need to change the
> >> > kernel at all.
> >
> > What's wrong with using libudev ? Well, fist of all I have never heard
> > about it:), one can argue this is kind of my fault, and second of all
> > the documentation is kind of non-existent (almost).
> 
> What else do you need?
>   http://www.kernel.org/pub/linux/utils/kernel/hotplug/libudev/
> 
> Let me know, we can add it.
> 
> Thanks,
> Kay
> 

Well, this is not really documentation right, but rather reference
manual. But I found this

http://www.signal11.us/oss/udev/

as a good way to start with.

Thanks!

-Lukas
--571108635-327484916-1292003692=:2813--
