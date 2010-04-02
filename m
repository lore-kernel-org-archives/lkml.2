Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0DBWJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 18:09:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:44721 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755156Ab0DBWJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 18:09:24 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX19p6X0zmRNpbUBQJvVkZs7E1VhwaRE5EP2rbbBJeR
	oNnUXXhFt2DzuF
Message-ID: <4BB66B16.10003@gmx.net>
Date: Sat, 03 Apr 2010 00:09:26 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090410 SUSE/1.1.18-0.1 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
Subject: Re: BUG: physmap modprobe & rmmod
References: <20100402134058.c4682716.randy.dunlap@oracle.com> <20100402144727.2c80a6b2.randy.dunlap@oracle.com>
In-Reply-To: <20100402144727.2c80a6b2.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.04.2010 23:47, Randy Dunlap wrote:
> On Fri, 2 Apr 2010 13:40:58 -0700 Randy Dunlap wrote:
>
>   
>> 2.6.34-rc2 kernel:
>>
>> Boot up on a common PC, then: modprobe physmap ; rmmod physmap
>> and bang.
>>     
> This is with close to an allmodconfig on x86_64, including:
>
> CONFIG_MTD_PHYSMAP=m
> CONFIG_MTD_PHYSMAP_COMPAT=y
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
>   

Forgive me if this sounds weird, but I was under the impression that
most people who want to reflash their BIOS on x86 (most prominent
physmap usecase on x86) are using a pure userspace solution with
flashrom <http://www.flashrom.org/> nowadays.

flashrom has the advantage of not needing a kernel recompile if you want
support for new chips/chipsets. flashrom doesn't use MTD and accesses
/dev/mem instead. AFAIK flashrom supports BIOS/EFI/... flashing on all
x86 chipsets which are supported by MTD, and on a few other x86 chipsets
(and network/storage/graphics cards) which are not supported by MTD.

Regards,
Carl-Daniel
