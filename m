Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2DHX1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab2DHX1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:27:32 -0400
Date: Sun, 8 Apr 2012 19:27:28 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xin Tong <xerox.time.tech@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: oostore on x86
Message-ID: <20120408232728.GA29407@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Xin Tong <xerox.time.tech@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CALKntY1V2nELdTOSVpm1PwVmxm1pxtGdvs8tUyNA1R=c9K8pcA@mail.gmail.com>
 <4F820804.2040302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F820804.2040302@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2012 at 02:49:56PM -0700, H. Peter Anvin wrote:
 > On 04/07/2012 12:48 PM, Xin Tong wrote:
 > > how can one enable oostore on x86, does one need to recompile the kernel ?
 > 
 > Yes, and expect the code to have seriously bitrotted.
 
It also only ever worked on the early IDT Winchip processors.
They weren't particularly great when they came out in the late 90s,
and I doubt they've improved with age.

I'd estimate the number of people running anything newer than a
2.4 kernel on those chips to be approximating zero, largely because
those old systems rarely had a lot of memory, and modern 2.6 capable
distros probably run like a dog on them.

I've suggested just removing that code in the past a few times.
Even if it does still work, anyone complaining about performance loss
of a modern kernel on something of that era can't be taken seriously.

	Dave

