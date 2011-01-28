Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab1A1FOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:14:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43624 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1A1FOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KUZQpQt0P/0m0LmgDPebWFzGdhPKJk8F0jx3Hzyk9RGiNGNyx3+VidIn5henXlga8e
         /oJtXnv77F4VFslcjT1wRrtelgoy7mP6oqOPxVOoCeVUA+TWcvJFFk46Eb6pK6Cj0901
         oFRdVKwwcwnpmxcOnqBRmx5pd2DXQsg7JL130=
MIME-Version: 1.0
Date: Fri, 28 Jan 2011 10:44:19 +0530
Message-ID: <AANLkTi=+Hx+3Jk0yprAffhvQM+WcO+WytaLBU-vwbetc@mail.gmail.com>
Subject: equivalent of phys_to_virt in an iommu system
From: MJ embd <mj.embd@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Assuming at core mmu there is a mapping, V1 -> P1
And at the IOMMU for the device to access a region of DDR there is a
mapping P2 -> P1. [P2 is the address on which device issues a r/w]

Now the device driver does the following.

Line 0: V1 = kmalloc();
Line 1: P2 = dma_map_single(V1)

Now if later in the driver, there is a requirement to get V1 from P2
what is the primitive in linux  ?
Also is my understanding of Line 1(above) correct ?


-- 
-mj
