Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0JUAXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:23:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37611 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0JUAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Q3Od9EBqop593nKhRoc1IWTuTo5NDvm6ZJGBDue326XnRA6W4pVW+EQWemGnSxDCl6
         RwlDwPV1Tx3z+oWXi75L83wUMxnoRyW9cYc8/jFDBAgQmdq1i4FJa+2vyfB5efXqB02x
         uy++qcuTixJRu83+719tDgNPtoOpr297xwxSA=
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 02:23:11 +0200
Message-ID: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com>
Subject: [RFC] Removal of dead code from arch/arm/*
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I will begin testing this, I would like to know your opinion about this patches
git pull git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git rodc1

 arch/arm/kernel/time.c                       |    6 +-
 arch/arm/mach-omap1/board-sx1.c              |   27 -
 arch/arm/mach-omap1/pm.c                     |    7 -
 arch/arm/mach-s3c2410/include/mach/gpio.h    |    4 -
 arch/arm/mach-s3c2443/mach-smdk2443.c        |    8 -
 arch/arm/mach-sa1100/include/mach/SA-1101.h  |  925 --------------------------
 arch/arm/mach-sa1100/include/mach/hardware.h |    4 -
 arch/arm/mach-u300/clock.c                   |   91 ---
 arch/arm/plat-mxc/include/mach/mx51.h        |    4 -
 arch/m32r/kernel/time.c                      |    6 +-
 drivers/acpi/proc.c                          |    2 +-
 11 files changed, 3 insertions(+), 1081 deletions(-)


-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
