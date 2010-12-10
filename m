Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0LJSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:25:29 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:55058 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0LJSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:25:28 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012101855070.2813@dhcp-lab-213.englab.brq.redhat.com>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
 <20101209192050.GA26457@suse.de> <A9CA290C-6611-478D-B6DD-8DF443575FC4@dilger.ca>
 <alpine.LFD.2.00.1012101427270.2813@dhcp-lab-213.englab.brq.redhat.com>
 <20101210173406.GA11936@suse.de> <alpine.LFD.2.00.1012101855070.2813@dhcp-lab-213.englab.brq.redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 10 Dec 2010 19:25:12 +0100
Message-ID: <AANLkTimRiTJf51OBNzrCjiStTTiYfbFLJaXq=vE=JPBY@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
To: Lukas Czerner <lczerner@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, sandeen@redhat.com, hch@infradead.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 18:59, Lukas Czerner <lczerner@redhat.com> wrote:

> I do not really see how, reference manual is not exactly helpful with
> this and I have got the impression that libudev functions are not able
> to retrieve queue information, but rather device properties, basically
> only from /sys/block/sda/* directory, not subdirectories.

Device subdirs are like attribute groups, the actual attribute just
has a / in it.

Kay
