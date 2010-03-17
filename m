Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0CQCHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:07:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0CQCHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:07:45 -0400
Message-ID: <4BA03957.8010103@kernel.org>
Date: Wed, 17 Mar 2010 11:07:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: James Bottomley <James.Bottomley@suse.de>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>	<1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>	<4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>	<4B9F2388.2030803@kernel.org>	<1268745897.21384.14.camel@mulgrave.site>	<4B9F8E1A.2020608@kernel.org>	<1268749297.21384.15.camel@mulgrave.site>	<4B9F9AAF.6080709@kernel.org>	<1268751748.21384.18.camel@mulgrave.site>	<4B9FA1C6.7090305@kernel.org> <yq1634wp9zx.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1634wp9zx.fsf@sermon.lab.mkp.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 02:07:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/17/2010 12:22 AM, Martin K. Petersen wrote:
>>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:
> 
> Tejun> * Anything remotely modern (>= XP) doesn't give a hoot about
> Tejun>   cylinder alignment.
> 
> Tejun> * Anything older (<= 2000) is very likely to get confused with
> Tejun>   custom geometry starting from the BIOS itself.  For those
> Tejun>   cases, the only thing we can do is aligning partitions to
> Tejun>   cylinders abiding BIOS supplied geometry parameters which will
> Tejun>   usually be 255/63.
> 
> Tejun> So, using custom geometry doesn't help compatibility at all.
> 
> Great reads on this topic.  Might be worth linking to:
>
> 	http://www.win.tue.nl/~aeb/partitions/partition_types.html
> 	http://www.win.tue.nl/~aeb/linux/largedisk.html

Thanks for the links.  I'll read and link them.  BTW, if you can spot
something wrong regarding this in the doc, please let me know.  I'm
still learning how all these legacy stuff is supposed to work so there
likely are some points that I got wrong.

-- 
tejun
