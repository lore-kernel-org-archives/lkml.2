Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0LJRv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:51:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55958 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0LJRv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:51:27 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012101427270.2813@dhcp-lab-213.englab.brq.redhat.com>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
 <20101209192050.GA26457@suse.de> <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca>
 <alpine.LFD.2.00.1012101427270.2813@dhcp-lab-213.englab.brq.redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 10 Dec 2010 18:51:10 +0100
Message-ID: <AANLkTinQ+3BAEac44-TkiKjG-A5FiYsnXtgpZHi3T=qj@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
To: Lukas Czerner <lczerner@redhat.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Greg KH <gregkh@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, sandeen@redhat.com, hch@infradead.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 15:07, Lukas Czerner <lczerner@redhat.com> wrote:
> On Thu, 9 Dec 2010, Andreas Dilger wrote:
>
>> On 2010-12-09, at 12:20, Greg KH wrote:
>> > On Thu, Dec 09, 2010 at 04:25:35PM +0100, Lukas Czerner wrote:
>> >> For a long time it has been pretty painful to retrieve informations from
>> >> /sys/block/*/queue for particular block device. Not only it is painful
>> >> to retrieve informations within C tool, parsing strings, etc, but one
>> >> have to run into problem even finding the proper path in sysfs.
>> >
>> > What's wrong with using libudev?  That should give you all of this
>> > information easily using a .c program without any need to change the
>> > kernel at all.
>
> What's wrong with using libudev ? Well, fist of all I have never heard
> about it:), one can argue this is kind of my fault, and second of all
> the documentation is kind of non-existent (almost).

What else do you need?
  http://www.kernel.org/pub/linux/utils/kernel/hotplug/libudev/

Let me know, we can add it.

Thanks,
Kay
