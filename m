Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2GCHUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:20:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29822 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2GCHUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:20:50 -0400
X-AuditID: cbfee60f-b7f406d00000703d-d5-4ff29d46eedb
Date: Tue, 03 Jul 2012 07:20:38 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] Extcon: Arizona: Add driver for Wolfson Arizona class
 devices
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120703071724351@myungjoo.ham
Msgkey: 20120703071724351@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120703071724351@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <4681354.107331341300035007.JavaMail.weblogic@epml05>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/t6bpucz/5G+zcZ2RxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyTnVfZSzYw1Wx7sZv9gbGKVxdjJwcQgLqEouWnGQDsSUETCQ6
	Zz9ghbDFJC7cWw8U5wKqmc8osffkGaYuRg4OFgEViYXXikFMNgE9iZmfk0HKhQXCJJqnvwMb
	IyJgJvHo/392kFZmgR9MEivPLWeH2KUksWbfKxYQm1dAUOLkzCcsELtUJTp/PWeGiKtJLHu+
	HOoeCYlZ0y9A3cMrMaP9KVS9nMS0r2uYIWxpifOzNjDC3Lz4+2OoOL/Esds7wE4G6X1yPxhm
	zO7NX6DGC0hMPXOQEaJES+LpTg+IMJ/EmoVvWWCm7Dq1nBmm9f6WuUwgNrOAosSU7ofsELaW
	xJcf+9jQfcUr4Cgx68oy9gmMcrOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXFSemppnrFibnFpXnp
	esn5uZsYwTH+jH8H46IGi0OMAhyMSjy8PLWf/IVYE8uKK3MPMUpwMCuJ8MYd+egvxJuSWFmV
	WpQfX1Sak1p8iFGag0VJnLfX+oK/kEB6YklqdmpqQWoRTJaJg1OqgXHP0fQzqjc+ly85u3vL
	Tk21bIlwCc7WG/Ff3xvIzTASf6S99aJw7p5DKco+3FFLHhxsTlVkcmLyXu3a/Hkan22tV2DL
	kgXP/pVu5F01aY1hN5dKacWU6U3rXs4y59t4vO7u/vyPqR9mzeJ5dXrf2sLq8llvD6h+4hfS
	/qar1ll/+8tnw7UPXm9XYinOSDTUYi4qTgQAwAwnMe0CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q637Ku44014248

Hello Mark,

Though extcon-arizona.c itself does not seem to have problems, when I add the patches from your repository (http://git.kernel.org/?p=linux/kernel/git/broonie/misc.git;a=commit;h=3afbac957e3c59037a4ecaf19d68f6c8104299fc), I get compiler errors if MFD_ARIZONA is enabled in order to enable EXTCON_ARIZONA. (No other Arizona-related devices are enabled; I don't have any of them anyway) This is not an issue w/ extcon-arizona.c, but I just wanted to let you know.

  CC      drivers/extcon/extcon-arizona.o
  LD      drivers/extcon/built-in.o
  CC      drivers/mfd/wm5102-tables.o
  CC      drivers/mfd/max8997-irq.o
drivers/mfd/wm5102-tables.c:601:2: error: unknown field °Æwake_base°Ø specified in initializer
make[2]: *** [drivers/mfd/wm5102-tables.o] Error 1
make[2]: *** Waiting for unfinished jobs....
  CC      drivers/staging/staging.o
make[1]: *** [drivers/mfd] Error 2
make[1]: *** Waiting for unfinished jobs....


Cheers!
MyungJoo.

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
