Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab2JWOlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:41:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2JWOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:41:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v2 0/4] zynq subarch cleanups
Date: Tue, 23 Oct 2012 14:41:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, John Linn <john.linn@xilinx.com>
References: <20121022211040.GA31538@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121022211040.GA31538@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210231441.29107.arnd@arndb.de>
X-Provags-ID: V02:K0:YUgAlUnS9j/3nPXngFGP1OzkOIIfeNN1VSIPBm8El5X
 gRFbVLVBwGnOd5PAr1YdiVuRBstfFv0UyctBLNHVXFK6CMlwJA
 XCbpcNsUOMo7y6i+aSSpVjjiv3hfAJnxWW6oGjHi8nFZpoLowt
 L7cP0bMxd4WfDnIs3uLZKrAPBfCm5moZgi/n4b6id6Alb2rO8j
 XE+yiS6qhEVXPS7j2PFJ3O2oVqO1PSdfixOAWP843NMjg7dmvS
 jshxWSvS/kUW+yRIvZZEYbHyHQh2pJYtGeNaR/Z5bcYT2op54c
 Rce5Mb8lKpl/MvNynrXVQOKKjxuzRzLoLecliHta0xFcCB2HX6
 aETL0bnsWfzNhPBF7VkM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2012, Josh Cartwright wrote:
> Hey all-
> 
> Things have been relatively quiet on the Zynq front lately.  This
> patchset does a bit of cleanup of the Zynq subarchitecture.  It was the
> necessary set of things I had to do to get a zynq target booting with
> the upstream qemu model.  It removes some unused clock infrastructure,
> adds DT support for the GIC, and moves around peripheral mappings.

Ok, thanks for these patches. As we have moved on for some of these issues,
I'll comment on how to go even further. On a global scale, I wonder
if there are any obstacles for enabling CONFIG_MULTIPLATFORM on Zynq
as we have done for most of the other recently added platform.

	Arnd

