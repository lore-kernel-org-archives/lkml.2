Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab0JUNHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:07:47 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42620 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab0JUNHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:07:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hbf7Yh3Y7JPJaqwT2EtejyqTEZFofB50zhwS9BwqEshz5hDEN9NlT9WeA+CgAkok9e
         DNY1cpHUybExkpldW8ZTOEmjM6aUfohL1GW21a+a1pkuI++fxrIITfaLnMZ8Ap5QimaZ
         N5eWPLA5jS2B9LZ5RghrIU3t/xrdSPXBTVJoA=
MIME-Version: 1.0
In-Reply-To: <AANLkTim=vGmaBRBNtAAPhcZ8CfwCFSCm_0ewY78WHeaM@mail.gmail.com>
References: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com>
	<AANLkTi=Cpq2_vV2RGcoQhrqk8xpL59AvLFPzfvTBk5Xa@mail.gmail.com>
	<4CBF8BDB.7090907@gmail.com>
	<20101021075401.GC22100@n2100.arm.linux.org.uk>
	<AANLkTikjByC1_BQvPv=Stkdph1cV=a8CwcqrcBv6u0+p@mail.gmail.com>
	<AANLkTik=27zjJacQTQhd6E4rGuERg19rAd5cgnLTDEoR@mail.gmail.com>
	<AANLkTimHWtJDV+ZkRnLY5sPmBGC-Z9wHaZwT2KBAN2nv@mail.gmail.com>
	<AANLkTim=vGmaBRBNtAAPhcZ8CfwCFSCm_0ewY78WHeaM@mail.gmail.com>
Date: Thu, 21 Oct 2010 15:07:44 +0200
Message-ID: <AANLkTi=UKh-vCLpta_ViTgbHcRrE6Lq3rFb_omXZdb+4@mail.gmail.com>
Subject: Re: [RFC] Removal of dead code from arch/arm/*
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/21 Zimny Lech <napohybelskurwysynom2010@gmail.com>:
> 2010/10/21 Zimny Lech <napohybelskurwysynom2010@gmail.com>:
>
>> Another one
>
> drivers/scsi/qla4xxx/ql4_nx.c: In function ‘qla4_8xxx_pci_mem_read_direct’:
> drivers/scsi/qla4xxx/ql4_nx.c:716: error: implicit declaration of
> function ‘readq’
> drivers/scsi/qla4xxx/ql4_nx.c: In function ‘qla4_8xxx_pci_mem_write_direct’:
> drivers/scsi/qla4xxx/ql4_nx.c:787: error: implicit declaration of
> function ‘writeq’


  CC      drivers/scsi/advansys.o
drivers/scsi/advansys.c:72:2: warning: #warning this driver is still
not properly converted to the DMA API
drivers/scsi/advansys.c: In function ‘AdvBuildCarrierFreelist’:
[..]
drivers/scsi/advansys.c:9360: warning: ‘virt_to_bus’ is deprecated
(declared at /home/test/linux-2.6/arch/arm/include/asm/memory.h:222)

drivers/serial/uartlite.c: In function ‘ulite_receive’:
drivers/serial/uartlite.c:90: error: implicit declaration of function
‘ioread32be’
drivers/serial/uartlite.c: In function ‘ulite_transmit’:
drivers/serial/uartlite.c:135: error: implicit declaration of function
‘iowrite32be’


Is it at all possible to build these things on arm? Maybe this should
be disabled on arm?

-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
