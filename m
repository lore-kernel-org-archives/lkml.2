Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2IRIc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:32:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab2IRIcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:32:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 22/24] scsi: eesox: use __iomem pointers for MMIO
Date: Tue, 18 Sep 2012 08:09:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
References: <201209150800.35605.arnd@arndb.de> <201209151030.44105.arnd@arndb.de> <20120917220334.GU12245@n2100.arm.linux.org.uk>
In-Reply-To: <20120917220334.GU12245@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209180809.58542.arnd@arndb.de>
X-Provags-ID: V02:K0:nVexuxgU88bqp8aNvTvGktGJpO2uyWZdxTlIe8gSBib
 aB4pLhv96SR7nHP8RrQulKgWcn9LmRz3YBYoQn8uwLQq4vmYPN
 D8LQqIVtggsaAhMWjsdJLnivpBf/IQeW3s8WggGGo701Nb/jYS
 OhyG3/lnEEneOIgqQUzFSNHowgSJq0Aw1uNpqE7KIVNoIS/rsg
 YvHmJ+lcdfN+uPgO3octknjH2mxdPFfu445r9rZoZdbn5skTXE
 XIssdz7PSWCK5+VYtncWj2/EtzZ+2ww8/TIKNFkmvf9RZppjAM
 ICbQpRjQs985fcFrefoPyUowU9BElMIiJRfe7UNxLO+32xNBE8
 rlNRC7ZL78J2iNihdoSY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2012, Russell King - ARM Linux wrote:
> In both of my replies, I've said "as x86 does".  We need to follow
> x86's behaviour here, which is as I've quoted - it's not a matter
> that "I need to make up my mind" - my mind is already well made up.
> That is, we need to follow x86 here.
> 
> That is, const volatile void __iomem * for reads, and volatile void
> __iomem * for writes.

Ok, I'll keep the patch in the series then, as it only changes the
pointer that we do an MMIO write on, not the ones for MMIO read.

	Arnd

