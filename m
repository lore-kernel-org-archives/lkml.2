Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0E1NmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:42:00 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:36481 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab0E1Nl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:41:59 -0400
Message-ID: <4BFFC821.1020509@msgid.tls.msk.ru>
Date: Fri, 28 May 2010 17:41:53 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Bastian Blank <waldi@debian.org>, xen-devel@lists.xensource.com,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix name of Xen event-channel device
References: <20100526105144.GA28280@wavehammer.waldi.eu.org> 	<20100527073512.GA17135@wavehammer.waldi.eu.org> <20100527143104.GB6040@wavehammer.waldi.eu.org> 	<20100527150251.GD6040@wavehammer.waldi.eu.org> <4BFEA2DF.8080006@msgid.tls.msk.ru> 	<20100527171313.GB11358@wavehammer.waldi.eu.org> <AANLkTinmhitag1oTssXB_ICXIriubGLNBvltS-Fuc8Cg@mail.gmail.com>
In-Reply-To: <AANLkTinmhitag1oTssXB_ICXIriubGLNBvltS-Fuc8Cg@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Thu, May 27, 2010 at 19:13, Bastian Blank <waldi@debian.org> wrote:
[]
>>>                             Also, how about other xen-related
>>> devices which are moved to /dev/xen in that same udev rules?
>> This is the only device currently supported by the vanilla kernel,
>> everything else is in the Xen tree only.
> 
> And naming of primary device nodes is no longer udev's task. All these
> rules are removed from the default udev rules. These names must all
> come from the kernel these days. Udev will log errors if udev rules
> specify names which are not in sync with the kernel, so they can be
> fixed in the kernel or in the rules.

Finally!...  It's been hashed and rehashed back when udevd were
invented to replace devfs and we returned back to traditional
kernel-generated names for a base.  Oh well...

That's, actually, _excellent_ news, something that bothered me
for all these years since 2.4 kernel - that I don't have some
devices in /dev (because they're named differently or moved to
a subdir) which are mentioned in dmesg or sysfs.  Hooray!

Will check for all sound (/dev/snd/), input (/dev/input/), usb
(/dev/usb/) and oh, the famous tun (/dev/net/tun) devices - you
intrigued me!.. ;)

Thanks!

/mjt
