Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1ITUzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:55:31 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:37073 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1ITUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:55:30 -0400
MIME-Version: 1.0
In-Reply-To: <yun1uvbf7zp.fsf@aiko.keithp.com>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com>
	<yunbousl9f5.fsf@aiko.keithp.com>
	<CAC9WiBgn2cr7zY8_9j7SEwQ+rPye9s3cM+Ex4WUxam78qAZhRQ@mail.gmail.com>
	<yun1uvbf7zp.fsf@aiko.keithp.com>
Date: Tue, 20 Sep 2011 22:55:29 +0200
Message-ID: <CAC9WiBhofPXDy+=aMiV4K+LyXMu76vvwGxx-w7biQd8_=WpW5A@mail.gmail.com>
Subject: Re: 3.1-rc5 is the worst
From: Francis Moreau <francis.moro@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 7:18 PM, Keith Packard <keithp@keithp.com> wrote:
> On Sun, 11 Sep 2011 20:33:14 +0200, Francis Moreau <francis.moro@gmail.com> wrote:
>
>> Ok this seems to fix the issue.
>
> I've posted a patch that disables fbc by default on Ironlake machines;
> I'd like to have it tested to make sure it actually does what it's
> supposed to do, and resolves the issue for you without a special kernel
> command line argument. If it does, I'll make sure this lands in 3.1

Ok will test and report the result tomorrow (Wednesday).

Thanks
-- 
Francis
