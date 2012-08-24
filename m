Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab2HXTeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:34:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36583 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2HXTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
References: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
Date: Fri, 24 Aug 2012 15:34:18 -0400
Message-ID: <CAEhu1-5VLuFsZomDZ1yxixqD7oLEhoXs+N698_VBkdGz5trK8g@mail.gmail.com>
Subject: Re: Possible mptsas regression post 3.5.0
From: John Drescher <drescherjm@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 1:34 PM, John Drescher <drescherjm@gmail.com> wrote:
> Over the last few weeks I have done some reliability testing with
> mdraid6 on a machine with 2 lsi mptsas controllers and 13 SATA I
> drives. My testing involved physically hot removing a drive forcing
> the raid to grab a spare and rebuild. This worked great for the 5 or
> so times I did this on gentoo-sources-3.5.0 and lower. However any
> attempt to do this on gentoo-sources-3.5.1 or even the 3.6-rc2 git
> resulted in a total lockup of the array. I originally thought this was
> a mdadm regression and posted about that last week here:
>
> https://lkml.org/lkml/2012/8/17/503
>

I have bisected the kernel a few times now and the problem was
introduced between
3.5.0.00007-ged29dbd
3.5.0.00015-g4d9157e

After the raid rebuilds again I will bisect again and see if I can
narrow it down to the exact patch.

John
