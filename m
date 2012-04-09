Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2DICPz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:15:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64212 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2DICPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:15:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120408232728.GA29407@redhat.com>
References: <CALKntY1V2nELdTOSVpm1PwVmxm1pxtGdvs8tUyNA1R=c9K8pcA@mail.gmail.com>
	<4F820804.2040302@zytor.com>
	<20120408232728.GA29407@redhat.com>
Date: Sun, 8 Apr 2012 22:15:53 -0400
Message-ID: <CALKntY3tnQOT5U+U85_Wj1fitztRz8zo1_75QLKu8HbCf_+hdw@mail.gmail.com>
Subject: Re: oostore on x86
From: Xin Tong <xerox.time.tech@gmail.com>
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Xin Tong <xerox.time.tech@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to relax the amd64 memory model. does the latest intel
processor micro-architecture support it ?

Xin


On Sun, Apr 8, 2012 at 7:27 PM, Dave Jones <davej@redhat.com> wrote:
> On Sun, Apr 08, 2012 at 02:49:56PM -0700, H. Peter Anvin wrote:
>  > On 04/07/2012 12:48 PM, Xin Tong wrote:
>  > > how can one enable oostore on x86, does one need to recompile the kernel ?
>  >
>  > Yes, and expect the code to have seriously bitrotted.
>
> It also only ever worked on the early IDT Winchip processors.
> They weren't particularly great when they came out in the late 90s,
> and I doubt they've improved with age.
>
> I'd estimate the number of people running anything newer than a
> 2.4 kernel on those chips to be approximating zero, largely because
> those old systems rarely had a lot of memory, and modern 2.6 capable
> distros probably run like a dog on them.
>
> I've suggested just removing that code in the past a few times.
> Even if it does still work, anyone complaining about performance loss
> of a modern kernel on something of that era can't be taken seriously.
>
>        Dave
>
