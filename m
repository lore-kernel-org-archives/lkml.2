Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0IAL45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:56:57 -0400
Received: from v002983.home.net.pl ([212.85.107.189]:51224 "HELO
	v002983.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752743Ab0IAL4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:56:55 -0400
From: Hubert Kario <hka@qbs.com.pl>
Organization: QBS Jan =?utf-8?q?Kuba=C5=84?=
To: Ben Chociej <bchociej@gmail.com>
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Date: Wed, 1 Sep 2010 13:56:49 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-ARCH; KDE/4.5.0; i686; ; )
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
        crscott@us.ibm.com, mlupfer@gmail.com, conscott@vt.edu
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com> <20100813131422.GA615@centrinvest.ru> <AANLkTinQAa=DujQ2Tm1oi2kVqF9z1RX2_M3SCCO_MKZG@mail.gmail.com>
In-Reply-To: <AANLkTinQAa=DujQ2Tm1oi2kVqF9z1RX2_M3SCCO_MKZG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009011356.51609.hka@qbs.com.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 August 2010 16:10:24 Ben Chociej wrote:
> It's a good point, of course. Ideally we would be able to prioritize
> data and place them on 15k versus 7.2krpm disks, etc. However you get
> to a point where's there's only incremental benefit. For that reason,
> the scope of this project was simply to take advantage of SSD and HDD
> in hybrid. Of course, you could register the same complaint about the
> ZFS SSD caching: why not take advantage of faster vs. slower spinning
> disks? Unfortunately it just wasn't in the scope of our 12-week
> project here.
> 
> That's not to say it *shouldn't* be done in the future, of course!
> And, incidentally, you could hack it together at this point by setting
> the /sys/block/<blockdev>/queue/rotational flag to 0 and using it like
> an SSD. :)

Then why not make the devices with rotational at 0 be the default "SSDs" but 
allow the admin to set manually others, without hacking?

You can have SSDs in a hardware RAID array, this way the kernel may not know 
if the block device is on flash media or on rotational media...

-- 
Hubert Kario
QBS - Quality Business Software
ul. Ksawerów 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
