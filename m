Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab1GOAmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:42:12 -0400
Received: from host1743200242118.direcway.com ([174.32.118.242]:33646 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab1GOAmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:42:10 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Re: large initramfs causes h/w reset after decompressing
Date: Thu, 14 Jul 2011 17:35:36 -0700
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>
References: <201107140906.46404.jzb2@aexorsyst.com> <201107141635.07673.jzb2@aexorsyst.com> <4E1F86AE.9090903@zytor.com>
In-Reply-To: <4E1F86AE.9090903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107141735.36175.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Sorry, I thought initramfs would be clear on its own that its not
> > initrd, but I guess some people do use it interchangeably.  Anyway,
> > I have some experience in programming, so is there anything you
> > could suggest that I might tweak to test your theory on the
> > decompressor?  Or would this be more of a kernel VM allocator
> > issue?  Also, would ramdisk_size have any bearing on this?
>
> initramfs can be built in or loaded via the initrd protocol.
>
> Anyway, it's hard to say for sure what to look for, but the first
> thing is to try to "fence" the problem... that is, establish the
> latest point which is successfully crossed and the earliest point
> which is not.

Fair enough...I'll start with a 2 GB boundary and see where it takes 
me...thanks for you feedback.

--john

