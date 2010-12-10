Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0LJSig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:38:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab0LJSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:38:35 -0500
Date: Fri, 10 Dec 2010 19:38:21 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Lukas Czerner <lczerner@redhat.com>, Greg KH <gregkh@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, sandeen@redhat.com, hch@infradead.org, axboe@kernel.dk
Subject: Re: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
In-Reply-To: <AANLkTimRiTJf51OBNzrCjiStTTiYfbFLJaXq=vE=JPBY@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1012101932440.2813@dhcp-lab-213.englab.brq.redhat.com>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com> <20101209192050.GA26457@suse.de> <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca> <alpine.LFD.2.00.1012101427270.2813@dhcp-lab-213.englab.brq.redhat.com> <20101210173406.GA11936@suse.de>
 <alpine.LFD.2.00.1012101855070.2813@dhcp-lab-213.englab.brq.redhat.com> <AANLkTimRiTJf51OBNzrCjiStTTiYfbFLJaXq=vE=JPBY@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Kay Sievers wrote:

> On Fri, Dec 10, 2010 at 18:59, Lukas Czerner <lczerner@redhat.com> wrote:
> 
> > I do not really see how, reference manual is not exactly helpful with
> > this and I have got the impression that libudev functions are not able
> > to retrieve queue information, but rather device properties, basically
> > only from /sys/block/sda/* directory, not subdirectories.
> 
> Device subdirs are like attribute groups, the actual attribute just
> has a / in it.
> 
> Kay
> 

*hrm* it would _really_ use better documentation! I already tried what
you've described without any success using:

udev_device_get_property_value() <- no description at all!

however it does work with:

udev_device_get_sysattr_value ()

sysattr ? property ? tags ? this is all confusing and again, reference
manual is not documentation. But it works, so thanks!

-Lukas
