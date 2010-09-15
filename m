Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0IOAh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 20:37:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50825 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0IOAh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 20:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CG4HpCnJt6YmaV6DE/ns0ksJ8X4oJk74vozFGLNpnB6USy2/c88iAASNqWQG55cL3x
         x73xCMZMxcUyuBSDRyvv5MBNNu74E5O/NXIX7yT+F/FkMSAkMaeeR4EGw9HADuQ0m4Yr
         fWzHuyZZ52MUO1zHan5+eqxaOs3yM7Zmd8SDk=
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
References: <1284284969.2928.18.camel@maxim-laptop>
	 <1284427621.4127.7.camel@maxim-laptop> <4C8F2699.3020509@kernel.org>
	 <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
	 <1284507516.4963.2.camel@maxim-laptop>
	 <AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 02:37:51 +0200
Message-ID: <1284511071.3551.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 01:49 +0200, Kay Sievers wrote: 
> On Wed, Sep 15, 2010 at 01:38, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > On Tue, 2010-09-14 at 10:07 +0200, Kay Sievers wrote:
> 
> >> Are we sure, that there is something that still polls the drive?
> >> Udisks is only auto-started, when the desktop calls into some D-Bus
> >> methods, unlike HAL where it was an init script.
> >
> > Note that on current vanilla head, I applied the attached manual revert
> > patch, and problem disappears (and probably introduces the same bug that
> > patch supposed to fix).
> 
> Can you please check which process polls the device, and attach an
> strace to it, to see what's going on?
As far as I can tell there is no such process.
(at least sudo fuser /dev/sr0 doesn't show up anything with or without
cd in the drive)


> 
> If there is no such process, does "touch /dev/sr0" create the missing event?
Yes.

Best regards,
Maxim Levitsky

