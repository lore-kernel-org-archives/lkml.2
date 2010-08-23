Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0HWULX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:11:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46472 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0HWULU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:11:20 -0400
Message-ID: <4C72D5E3.7070203@zytor.com>
Date: Mon, 23 Aug 2010 13:11:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
References: <4C728145.4030808@Free.fr> <20100823220506.7248c51b@schatten.dmk.lab>
In-Reply-To: <20100823220506.7248c51b@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2010 01:05 PM, Florian Mickler wrote:
> 
> I'm not exactly shure, but isn't the search command in grub2 what you
> want?
> 
> http://forums.linuxmint.com/viewtopic.php?f=46&t=38599
> 
> You can let grub2 figure out which drive is which and pass the right
> devices to the kernel...
> 

Fantastic!   So when grub2's idea of device naming doesn't match what
the kernel ends up with, it will cause all kinds of odd failures.

This really needs to be done by Linux.  As far as doing this stuff in
the kernel, one of the major motivations for klibc was to be able to do
this kind of stuff without having to have people write kernel code, but
klibc integrated into the kernel build didn't get enough support to
actually make it in -- it still exists and is maintained as a standalone
system, and it's possible to write a very small initramfs with it.

	-hpa
