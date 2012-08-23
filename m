Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab2HWTfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 15:35:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53721 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2HWTfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 15:35:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ7jCmkxS4Bor+XXvhh0Mpx5ZNyL8j8kED9KpbgMFJXED1ZoLw@mail.gmail.com>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208231814.21168.tweek@tweek.dk>
	<CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
	<CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
	<CAJ7jCmntV8kTup0=yLEmaGLP_vUDk4or3=UTWzODREO-pH8YxQ@mail.gmail.com>
	<CAMzpN2h8XCmEh2Xsw07_aYsW5yv87BmXNk-e6sb6gUg3eptoJw@mail.gmail.com>
	<CAJ7jCmkxS4Bor+XXvhh0Mpx5ZNyL8j8kED9KpbgMFJXED1ZoLw@mail.gmail.com>
Date: Thu, 23 Aug 2012 15:35:19 -0400
Message-ID: <CAMzpN2hfYzNwRR8o7Kz0qsuAo6JP1iSA91x=-DJP1tBz-smgTw@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: Brian Gerst <brgerst@gmail.com>
To: wbrana <wbrana@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 3:08 PM, wbrana <wbrana@gmail.com> wrote:
> On 8/23/12, Brian Gerst <brgerst@gmail.com> wrote:
>> Nobody here cares about closed source drivers.
> There are also open source software which don't support X32 like
> Oracle Java, VirtualBox, Mozilla Firefox, Google Chrome.

As I said before, X32 is an optional ABI in 64-bit kernels, for 64-bit
userspace code using 32-bit pointers to save memory.  Userspace
software doesn't have to support it, it can just go full 64-bit.  Any
kernel that supports X32 also supports the full 64-bit ABI.

--
Brian Gerst
