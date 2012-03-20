Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab2CTLqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:46:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53975 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab2CTLqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAD2nsn1SxhX3MZTF+XYN=cQEfHuD9bu5_TuLtVOCNmVBoZNJ2A@mail.gmail.com>
References: <4F576FD5.2050208@gmail.com>
	<CAD2nsn23UqshHz1ZUn8bHN0rWyOMbBHhn9V8pmCc4_aT_uGYaw@mail.gmail.com>
	<4F577D9B.7020402@gmail.com>
	<4F579A88.6030503@openwrt.org>
	<4F61F551.5010608@gmail.com>
	<4F639851.5080500@gmail.com>
	<4F674616.8080103@gmail.com>
	<CAD2nsn3xpkGenrK50YmE5D7Odg3sBEek5zKcLZF6MAm69p5RJg@mail.gmail.com>
	<4F674FF5.2060406@gmail.com>
	<4F6751B2.1030809@openwrt.org>
	<4F681B78.9000207@gmail.com>
	<CAD2nsn0d-3edYGH8u+v5mhrUZBMsznDNRDkDHE-tErG8uGk84Q@mail.gmail.com>
	<4F68235C.5090701@gmail.com>
	<CAD2nsn0toAjyWw48J7oREES0=x6D72hMntP+WpAjHmR5drd-tQ@mail.gmail.com>
	<4F682555.3020502@gmail.com>
	<20328.16366.166909.255035@gargle.gargle.HOWL>
	<CAD2nsn0JCKd4NnXOLfw4QXHTJdxrfepw9s6yYca=uSHwWXq3-A@mail.gmail.com>
	<CAD2nsn10svpDFkpbkCtFMGFdqW9G0syWrhL3s-ApQH2bKt0P2g@mail.gmail.com>
	<CAD2nsn1SxhX3MZTF+XYN=cQEfHuD9bu5_TuLtVOCNmVBoZNJ2A@mail.gmail.com>
Date: Tue, 20 Mar 2012 17:16:29 +0530
Message-ID: <CAD2nsn14z1mZJXxW12OzmN6mUhM0h0+TXtH797Y_czxx7gJH2A@mail.gmail.com>
Subject: Re: ath: DMA failed to stop in 10 ms AR_CR=0x00000024
 AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, linux-kernel@vger.kernel.org,
        Linux-netdev <netdev@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this should also fix
https://bugzilla.kernel.org/show_bug.cgi?id=42903

-- 
thanks,
shafi
