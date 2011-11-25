Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1KYUqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:46:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57821 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1KYUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:46:31 -0500
Date: Sat, 26 Nov 2011 00:46:26 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl
 for reading registers
Message-ID: <20111125204626.GA25003@oksana.dev.rtsoft.ru>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <CAHYPw2F3mYD2R4C_XCDc6wBbsEfz_wscEGdmHONhKRr9jbeEaw@mail.gmail.com>
 <20111125201011.GA14217@oksana.dev.rtsoft.ru>
 <7780165.E3DXgdWAv1@pali-elitebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7780165.E3DXgdWAv1@pali-elitebook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 09:30:28PM +0100, Pali Rohár wrote:
[...]
> This interface is not only for BME. Also some popular bq27200.sh script which 
> print bq registers in human readable form needs this interface (with 
> LD_PRELOAD library).
> 
> Link for that shell script http://enivax.net/jk/n900/bq.tar

That might be a good excuse to have the raw interface. Although,
as this is for debugging purposes only, the same effect can be
accomplished by unloading bq module and using i2c userspace
interface directly... I guess.

[...]
> > Is it possible to convert it to some "n900 charger driver"?
> 
> And two hours ago I started writing kernel driver for chip bq2415x which will 
> support charging battery. So I think yes!
> 
> So I think, one day I will delete BME from my Nokia N900.

That's a wonderful news! I really look forward to seeing it and
as n900 owner I very much appreciate your work.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
