Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2AWQTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:19:50 -0500
Received: from mail.servus.at ([193.170.194.20]:44544 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab2AWQTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:19:48 -0500
Message-ID: <4F1D889C.2050706@oberhumer.com>
Date: Mon, 23 Jan 2012 17:19:40 +0100
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>
Subject: ANN: linux-kernel-lzo-2.06.20120123 - update LZO to v2.06
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <4F16DFB0.2060404@oberhumer.com>
In-Reply-To: <4F16DFB0.2060404@oberhumer.com>
X-no-Archive: yes
X-Oberhumer-Conspiracy: There is no conspiracy. Trust us.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've prepared a small package that updates the LZO version in the Linux
kernel to LZO v2.06.

Please get it from:

  http://www.oberhumer.com/opensource/lzo/download/Testing/linux-kernel-lzo-2.06.20120123.tar.gz

As stated in the README, its main purpose is to allow easy benchmarking of the
latest LZO versions - these do feature some nice speed improvements, and while
I have done a lot of synthetic benchmarking I'm really very curious and
appreciate feedback on "real-world" performance numbers like usage in
btrfs and zram.

Share and enjoy,
Markus

http://www.oberhumer.com/opensource/lzo/

On 2012-01-18 16:05, Markus F.X.J. Oberhumer wrote:
> On 2012-01-13 01:28, Andi Kleen wrote:
>> Here's a slightly updated version of the BTRFS snappy interface.
>> snappy is a faster compression algorithm that provides similar
>> compression as LZO, but generally better performance.
> 
> I'd like to note that the LZO version in the current Linux kernel is
> rather outdated - it seems to be based on the 2005 release.
> 
> In fact the latest version LZO 2.06 does compress both slightly faster and
> better than snappy 1.0.4 when benchmarking the Calgary and Silesia
> compression corpus (tested with gcc 4.6 on Nehalem & Sandy Bridge).
> 
> Furthermore please be aware that from a pure compression point of view
> snappy et al. are very close cousins of LZO (strictly byte-aligned LZ77)
> that mainly differ in implementation issues like using a table to
> number of branches - and indeed similar optimizations could be applied
> to any version.
> 
> I'm not sure if there is an official kernel maintainer of LZO, but I'd
> offer to assist you updating to the latest version and eliminating
> any possible performance issues.

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
