Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1KYUKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:10:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33613 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab1KYUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:10:17 -0500
Date: Sat, 26 Nov 2011 00:10:11 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl
 for reading registers
Message-ID: <20111125201011.GA14217@oksana.dev.rtsoft.ru>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
 <1320108191-6647-8-git-send-email-pali.rohar@gmail.com>
 <4EAFE184.5010409@metafoo.de>
 <CAHYPw2EPdmmbk+DM1SgFKa8LGAKQEp7ppX+0Zjpkdx7hOcwzJA@mail.gmail.com>
 <4EAFEA3D.9030103@metafoo.de>
 <CAHYPw2F3mYD2R4C_XCDc6wBbsEfz_wscEGdmHONhKRr9jbeEaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHYPw2F3mYD2R4C_XCDc6wBbsEfz_wscEGdmHONhKRr9jbeEaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pali,

On Tue, Nov 01, 2011 at 01:53:26PM +0100, Pali Rohár wrote:
[...]
> >> Also on Nokia N900 is needed proprietary pogram BME for
> >> battery charging which need to access to bq27200 registers. A simple
> >> LD_PRELOAD library which wrap i2c-dev access to this device provided
> >> by this patch is here:
> >> https://code.launchpad.net/~pali/+junk/maemo_libbqioctl
> >
> > Yes, but that really is a hack to work around the closed source nature of the
> > BME program. I don't think we should put such hacks into the kernel.
> >
> 
> Not only BME. All programs (and shell scripts and all which use
> i2cget) need this interface, bacuse loading bq module will block
> ic2-dev.

A million thanks for your work! Though, on this particular patch I
agree with Lars-Peter here. The raw abi interface ought to exist only
because proprietary nature of BME, which is not good.

IIRC, there is some shell script that makes it possible to charge
N900 without BME? Is it possible to convert it to some "n900 charger
driver"?

I applied all patches from this series, except this one.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
