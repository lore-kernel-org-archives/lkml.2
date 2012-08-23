Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab2HWSyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:54:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43927 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934168Ab2HWSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208231814.21168.tweek@tweek.dk>
	<CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
Date: Thu, 23 Aug 2012 14:54:40 -0400
Message-ID: <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: Brian Gerst <brgerst@gmail.com>
To: wbrana <wbrana@gmail.com>
Cc: Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 1:22 PM, wbrana <wbrana@gmail.com> wrote:
> x86-32
> - is deprecated since Linux supports X32.
> - will slow down adoption of X32 - there won't be X32 versions of many
> software - if new ABI was added, old one should be removed

You misunderstand what the X32 ABI is.  It's 64-bit code (allowing use
of the extended register set) that uses 32-bit pointers to save
memory.  It has nothing to do with 32-bit kernels, and is completely
optional.

> - wastes time of developers who can spend their time supporting X32
> instead of x86-32 or support x86-64 only as 99% of users will be able
> to run x86-64 software if x86-32 will be dropped

The x86-32 arch is mature and well maintained, and shares so much in
common with x86-64, that there is little to be gained by dropping
kernel support.

> - wouldn't be dropped this year, but there should be plan when it will
> be dropped e.g. when Windows 9 will be released

Windows mostly sells with new hardware, and by the time win9 is
released all new hardware designed for it will be 64-bit capable.
Therefore it is not *profitable* for Microsoft to continue to develop
a 32-bit version.  That doesn't apply to Linux.  Linux is installed on
a broad range of hardware, new and old.  In general, we don't drop
support for hardware unless there is nobody willing to maintain it.

--
Brian Gerst
