Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1BPR0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:26:08 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33721 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1BPR0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l4IX/VT7J8UusnzPbKiiMFVKWU4Ewf6uyRPn9PcRPBCwfyc39P2hE0kBBZbM969XA4
         AmlMxfzvCh1sVHjS3f5gwq6pP0G0YqIKS/UY5ey8YnfKjufVWPpxkMQ24tlTsj1xH3i4
         dVGi8z8XW2r2pNcJGdXviL1DqlX3CH6ZQ8VVg=
MIME-Version: 1.0
In-Reply-To: <20110216152026.GA17102@redhat.com>
References: <m3aahwa4ib.fsf@fibrous.localdomain>
	<1297862209.2086.18.camel@morgan.silverblock.net>
	<m3ei78j9s7.fsf@fibrous.localdomain>
	<20110216152026.GA17102@redhat.com>
Date: Wed, 16 Feb 2011 09:25:57 -0800
Message-ID: <AANLkTikNKpo6aDVQVWC3FEiKFLv4JGFr=xPTC8Tu_2Sx@mail.gmail.com>
Subject: Re: [PATCH] [media] rc: do not enable remote controller adapters by default.
From: VDR User <user.vdr@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Stephen Wilson <wilsons@start.ca>, Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 7:20 AM, Jarod Wilson <jarod@redhat.com> wrote:
>> It is not a need.  I simply observed that after the IR_ to RC_ rename
>> there was another set of drivers being built which I did not ask for.
>
> So disable them. I think most people would rather have this support
> enabled so that remotes Just Work if a DTV card or stand-alone IR receiver
> is plugged in without having to hunt back through Kconfig options to
> figure out why it doesn't...

Unfortunately _ALL_ the usb DVB devices are unavailable if you do not
enable IR_CORE "Infrared remote controller adapters" in v4l.  This is
a little annoying as the usb device I use doesn't even have IR
capabilities.  It doesn't seem like something that should be forced on
the user -- enable IR or you can't even compile the driver you need,
which doesn't even use IR.

It's not the end of the world but I don't particularly appreciate the
enable-everything approach.  It would be nice to at least have the
option to trim the fat if you want.. Isn't that partially what Linux
is supposed to be about in the first place?

Just my two cents...
