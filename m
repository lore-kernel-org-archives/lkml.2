Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1GYKRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:17:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63740 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1GYKRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:17:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
	<m1r5n7ln0l.fsf@fess.ebiederm.org>
	<CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
Date: Mon, 25 Jul 2011 18:17:05 +0800
Message-ID: <CAKdQVUaKea64ROeDo-SLRgQ3sHptyxD2TjKKgK5OmS+28Ee1zw@mail.gmail.com>
Subject: Re: x86_64 virtual memory map
From: Bob Zhang <zhanglinbao@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: hayfeng Lee <omycle@gmail.com>, ak@linux.intel.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bob Zhang <2004.zhang@gmail.com>, zhanglinbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have HP's latest Proliant machine , The test involves using
configurations of 1 TB of Ram then 2TB of RAM. The system ROM is
reporting the proper amount of installed memory, however, Linux is
only reporting 992GB with both 1TB and 2 TB of memory in the system.
The customer has made the changes in the RMSU from 40 to 44 bit
addressing when using the 2TB of memory but this does not change
anything.
I am using SLES 11 SP1 (linux kernel is 2.6.32)
Does anyone have any idea how to get Linux to see the full amount of memory?
