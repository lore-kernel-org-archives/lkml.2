Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937915Ab0CPPiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:38:11 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:22748 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab0CPPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:38:09 -0400
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>,
       "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>
	<1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
	<4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>
	<4B9F2388.2030803@kernel.org>
	<1268745897.21384.14.camel@mulgrave.site>
	<4B9F8E1A.2020608@kernel.org>
	<1268749297.21384.15.camel@mulgrave.site>
	<4B9F9AAF.6080709@kernel.org>
	<1268751748.21384.18.camel@mulgrave.site>
	<4B9FA1C6.7090305@kernel.org>
Date: Tue, 16 Mar 2010 11:22:10 -0400
In-Reply-To: <4B9FA1C6.7090305@kernel.org> (Tejun Heo's message of "Wed, 17
	Mar 2010 00:20:38 +0900")
Message-ID: <yq1634wp9zx.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B9FA22D.0046:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:

Tejun> * Anything remotely modern (>= XP) doesn't give a hoot about
Tejun>   cylinder alignment.

Tejun> * Anything older (<= 2000) is very likely to get confused with
Tejun>   custom geometry starting from the BIOS itself.  For those
Tejun>   cases, the only thing we can do is aligning partitions to
Tejun>   cylinders abiding BIOS supplied geometry parameters which will
Tejun>   usually be 255/63.

Tejun> So, using custom geometry doesn't help compatibility at all.

Great reads on this topic.  Might be worth linking to:

	http://www.win.tue.nl/~aeb/partitions/partition_types.html

	http://www.win.tue.nl/~aeb/linux/largedisk.html

-- 
Martin K. Petersen	Oracle Linux Engineering
