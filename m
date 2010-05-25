Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab0EYU2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:28:22 -0400
Received: from ist.d-labs.de ([213.239.218.44]:42253 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0EYU2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:28:21 -0400
Date: Tue, 25 May 2010 22:28:14 +0200
From: Florian Mickler <florian@mickler.org>
To: linux-kernel@vger.kernel.org, ranjith kumar <ranjithproxy@gmail.com>
Subject: Re: building linux kernel
Message-ID: <20100525222814.4dc4a034@schatten.dmk.lab>
In-Reply-To: <AANLkTim7d3LpSp23LMOqwPz-Rnp0Idflf5JWUTDyplMU@mail.gmail.com>
References: <AANLkTim7d3LpSp23LMOqwPz-Rnp0Idflf5JWUTDyplMU@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 25 May 2010 16:50:31 +0530
ranjith kumar <ranjithproxy@gmail.com> wrote:

> Hi,
> 
> I am using fedora11 on my PC. I downloaded the linux kernel souce code.
> I copied config file from /boot directory and tried to compile. I am
> getting some compilation errors.
> So  I configured the kernel, with 'make defconfig', and it is
> compiling successfully.
> But when I am booting my machine with new kernel, it simply starts and
> displays '-' at top of the screen. nothing more.
> 
> My question is are fedora and linux kernel are connected or  not? If so how?
> I thinks linux kernel runs for a while, when it is booted. But after
> that control comes to fedora.
> 
> For example, in Fedora we can play chess.Windows are
> displayed.......etc ...many graphical things are there.
> I don't think that these gaphics, chess game.....are not part of linux kernel.
> Am I right?
> 
> Also, some time back when I was using fedora10, I configured linux
> kernel with /boot/ config file. I successfully compiled and run new
> linux kernel.
> When I boot with new kernel, it is still going into fedora. But when I
> run uname command it is showing new kernel version. But how come I was
> able to play chess game? chess game is not part of kernel.
> 
> 
> So if you got what I am asking, please tell me how to disconnect
> fedora and linux kernel? So when I boot with new kernel only kernel's
> things  should be running. not fedora's chess game. How to disconnect
> them?
> 
> Thanks in advance

Put init=/bin/sh on the kernel commandline to start directly into a
basic shell (instead of the complex "fedora"). 

The kernel is an abstraction layer, so that your chess game
(or /bin/sh) runs on all possible hardware. The kernel provides
mechanisms for the chess games (also known as a "userspace program") to
use the hardware, without knowing what hardware it is running on.

This is all basic system architecture. I didn't read the wikipedia
article on operating systems, but it i hope it is a good start:
http://en.wikipedia.org/wiki/Operating_system

Cheers,
Flo

p.s.: you may wanna post any follow on questions on kernel-newbies
mailinglist (kernelnewbies@nl.linux.org) , as lkml is mainly for
developing and not so much for explanation of basic system
architecture. 
