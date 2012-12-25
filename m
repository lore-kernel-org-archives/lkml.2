Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2LYLdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:33:31 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:65069 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2LYLd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:33:28 -0500
X-Greylist: delayed 13716 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2012 06:33:28 EST
MIME-Version: 1.0
In-Reply-To: <20121225111742.GB7720@liondog.tnic>
References: <CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com>
	<20121225111742.GB7720@liondog.tnic>
Date: Tue, 25 Dec 2012 06:25:11 -0500
Message-ID: <CAMmfjbNmN0pPXr-HY7qzK52YpwoSU76q1Puog951X7h099XHBA@mail.gmail.com>
Subject: Re: Does init start with any open files?
From: bbi5291 <bbi5291@gmail.com>
To: Borislav Petkov <bp@alien8.de>, bbi5291 <bbi5291@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, that can't be right---I grepped the kernel source for "initctl"
and got no results. Besides, if you're running a shell, then init has
already had time to open and close whatever file descriptors it wants
to. What I want to know is whether init has any open file descriptors,
at, say, the moment its main() starts executing.
________________________________
Brian Bi


On Tue, Dec 25, 2012 at 6:17 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Dec 25, 2012 at 02:38:09AM -0500, bbi5291 wrote:
>> When the init process is created on system startup, does it have any
>> open file descriptors? If so, where do they point?
>
> $ tree /proc/1/fd
> /proc/1/fd
> └── 10 -> /run/initctl
>
> 0 directories, 1 file
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
