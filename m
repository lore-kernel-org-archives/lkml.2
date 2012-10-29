Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab2J2ERJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 00:17:09 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:48886 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750800Ab2J2ERH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 00:17:07 -0400
Message-ID: <508E0345.1010600@xenotime.net>
Date: Sun, 28 Oct 2012 21:17:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Oct 29 (tty->raw)
References: <20121029144655.4a3d916780e0246f1f007c3e@canb.auug.org.au>
In-Reply-To: <20121029144655.4a3d916780e0246f1f007c3e@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2012 08:46 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20121026:
> 


Who made some changes that remove tty->raw ?

There is still one occurrence in arch/um that is causing
a build error (on x86_64 defconfig):

arch/um/drivers/chan_kern.c: In function 'tty_receive_char':
arch/um/drivers/chan_kern.c:89:42: error: 'struct tty_struct' has no member named 'raw'


-- 
~Randy
