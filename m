Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2LBQ7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 11:59:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42511 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2LBQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 11:59:37 -0500
Date: Sun, 2 Dec 2012 09:01:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/54] 3.6.9-stable review
Message-ID: <20121202170127.GD7858@kroah.com>
References: <20121130185207.894301294@linuxfoundation.org>
 <87txs5u8dn.wl%satoru.takeuchi@gmail.com>
 <20121201165027.GE3113@kroah.com>
 <CAKocOOPBdDkggsnBDwAVVuaQ30WLEzu0wLt_n4FkcE-Md_uSMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOPBdDkggsnBDwAVVuaQ30WLEzu0wLt_n4FkcE-Md_uSMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 07:11:48PM -0700, Shuah Khan wrote:
> On Sat, Dec 1, 2012 at 9:50 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sat, Dec 01, 2012 at 11:58:28PM +0900, Satoru Takeuchi wrote:
> >> At Fri, 30 Nov 2012 10:55:31 -0800,
> >> Greg Kroah-Hartman wrote:
> >> >
> >> > This is the start of the stable review cycle for the 3.6.9 release.
> >> > There are 54 patches in this series, all will be posted as a response
> >> > to this one.  If anyone has any issues with these being applied, please
> >> > let me know.
> >> >
> >> > Responses should be made by Sun Dec  2 18:51:00 UTC 2012.
> >> > Anything received after that time might be too late.
> >> >
> >> > The whole patch series can be found in one patch at:
> >> >     kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.9-rc1.gz
> >> > and the diffstat can be found below.
> >>
> >> 3.6.9-rc1 can be built and boot without any problem. Building a kernel with
> >> this kernel also works fine.
> >
> > Great, thanks for testing all three of these trees out and letting me
> > know.
> 
> Patch applied cleanly, compiled and booted on the following systems:
> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> Cross-compile tests passed on the following architectures:
> alpha
> arm
> c6x
> mips
> powerpc
> sh
> sparc
> tile
> 
> If you would like to see more architectures cross-compiled and on all
> releases, please let me know. I just did the cross-compiles on 3.6.y

Cross-compiling is great, thanks for doing that.

greg k-h
