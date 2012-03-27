Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2C0CSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 22:18:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42495 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab2C0CSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 22:18:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6661"; a="176023667"
X-IronPort-AV: E=Sophos;i="4.75,320,1330934400"; 
   d="scan'208";a="158104046"
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20337.9030.686697.228453@gargle.gargle.HOWL>
Date: Tue, 27 Mar 2012 07:47:42 +0530
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
        Linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, <linux-kernel@vger.kernel.org>,
        Linux-netdev <netdev@vger.kernel.org>
Subject: Re: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
In-Reply-To: <4F6FA388.9080408@gmail.com>
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
	<4F6FA388.9080408@gmail.com>
X-Mailer: VM 8.2.0a under 23.4.1 (x86_64-unknown-linux-gnu)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> I would have to say this patch above does get rid of this crash I was 
> seeing. as a quick test I simply connect to a WPA network, then connect 
> to an open network going back and forth triggers this freeze for me 
> after applying this I am able to toggle back and forth without a freeze.

Thanks for verifying.

Sujith
