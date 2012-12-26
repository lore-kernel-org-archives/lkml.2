Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2LZFiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 00:38:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23625 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2LZFiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 00:38:16 -0500
X-AuditID: cbfee60e-b7f856d0000024d4-0e-50da8d40cf31
Date: Wed, 26 Dec 2012 05:38:08 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: [3.8-rc1+] BUG: unable to handle kernel NULL pointer dereference,
 wait_iff_congested+0x45/0xdd
To: linux-kernel@vger.kernel.org
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20121226053658727@jongman.heo
Msgkey: 20121226053658727@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121226053058542@jongman.heo
X-ParentMTR: 20121226053058542@jongman.heo
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <27934635.301401356500288241.JavaMail.weblogic@epml05>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t8zbV2H3lsBBl0rZSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG8gdL2AqOSVT0XTvO1sD4QbyLkZNDSEBN4ubnQ4wgtoSAicTc
	13PZIWwxiQv31rN1MXIB1SxjlLjacJkJpuj7+/+sEIn5jBJff/xmBkmwCKhKfLx8hwXEZhPQ
	kej4v58VxBYWSJc4cHk6G4gtAlSz4+wKdojNihLXli4Gi/MKCEqcnPkEqJcDaIGKxMSb+SAm
	L1D5+Vd5EGslJGZNv8AKYfNKzGh/ygJhy0lM+7qGGcKWljg/awMjzP2Lvz+GivNLHLu9gwli
	Oq/Ek/vBMGN2b/7CBmELSEw9c5ARokRTYsnbUAhTW+LGfgeYIbtOLWeG6by/ZS44PJiB3pjS
	/ZAdwtaS+PJjH5qXQGwniXVfrjFBgklA4tvkQywTGJVmISmbhWTULCSjkNUsYGRZxSiaWpBc
	UJyUnmqiV5yYW1yal66XnJ+7iRGSEPh2MM5rsDjEKMDBqMTDu+n7zQAh1sSy4srcQ4wSHMxK
	IrzOH4FCvCmJlVWpRfnxRaU5qcWHGH2ArprILCWanA9MVnkl8YbGBsaGhpaGZqaWpgY4hJXE
	eZUqpgcICaQnlqRmp6YWpBbBjGPi4JRqYFx/WvKqRANTKNvr5bpek/Zrzvz+6N9KQcbybSv3
	nfjme3WF2sukFTUrInsWNO37zHBl65aNuw3WsyzhnnBC2m2KzI1cxzcbm54Kz5H06M9WNu0q
	uDmdz0A5em2rqv/3lvlh9gbvsr5s69HdYXf7LOdbp6y3L/bGuridDtp7qeOXh5wA04lbpblK
	LMUZiYZazEXFiQBjQ3fcNQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t/t6boOvbcCDJbPFre4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GcsfLGErOCZR0XftOFsD4wfxLkZODiEBNYmbnw8xgtgSAiYS39//Z4WwxSQu3FvP1sXIBVQz
	n1Hi64/fzCAJFgFViY+X77CA2GwCOhId//eDNQgLpEscuDydDcQWAarZcXYFO8QCRYlrSxeD
	xXkFBCVOznwC1MsBtEBFYuLNfBCTF6j8/Ks8iLUSErOmX4A6gVdiRvtTFghbTmLa1zXMELa0
	xPlZGxhhzlz8/TFUnF/i2O0dTBDTeSWe3A+GGbN78xc2CFtAYuqZg4wQJZoSS96GQpjaEjf2
	O8AM2XVqOTNM5/0tc5lAbGagN6Z0P2SHsLUkvvzYh+YlENtJYt2Xa0wTGGVnIUnNQtI+C0k7
	spoFjCyrGEVTC5ILipPSU030ihNzi0vz0vWS83M3MYJT0DO+HYzzGiwOMQpwMCrx8G76fjNA
	iDWxrLgy9xCjBAezkgiv80egEG9KYmVValF+fFFpTmrxIUYfYIRNZJYSTc4Hpse8knhDYwNj
	Q0NLcwNTQyMLHMJK4rxKFdMDhATSE0tSs1NTC1KLYMYxcXBKNTBGNEzxeOKwLu260D/uU/P6
	P9xYwJItuurrt87cuMR5G14/mP/hY7X6BZ698YvemCakn9m6btG9ALnGnevKZ5Rc+O4SsbD9
	1dRo36v/Lk4Wn3hfv/vSt5Mt2XwXBBdN25LkPGWOwta1hxpcrH6sKL+2K+ZIdmn4BFPNDVk9
	28Uu6WXp3rx34bHyaSWW4oxEQy3mouJEAMlbl0puAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBQ5cSJI016376


Hi,

During SVN checkout (means heavy I/O), I hit this kernel BUG with current linus git (637704cb : Merge branch 'i2c-embedded/for-next'), in my VMWare Linux guest.

[ 9141.015123] BUG: unable to handle kernel NULL pointer dereference at 00000280
[ 9141.017870] IP: [<c04ba69c>] wait_iff_congested+0x45/0xdd
[ 9141.034799] *pde = 00000000 
[ 9141.034803] Oops: 0000 [#1] SMP 
[ 9141.044282] Modules linked in: vmwgfx ttm drm
[ 9141.044331] Pid: 42, comm: kswapd0 Not tainted 3.8.0-rc1+ #120 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[ 9141.044334] EIP: 0060:[<c04ba69c>] EFLAGS: 00010202 CPU: 3
[ 9141.044342] EIP is at wait_iff_congested+0x45/0xdd
[ 9141.044343] EAX: 00000001 EBX: 00000000 ECX: 00000000 EDX: 00000000
[ 9141.044345] ESI: 0000001e EDI: f633fec0 EBP: f633fecc ESP: f633fea8
[ 9141.044347]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 9141.044348] CR0: 8005003b CR2: 00000280 CR3: 33ab7000 CR4: 000007d0
[ 9141.045817] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 9141.045834] DR6: ffff0ff0 DR7: 00000400
[ 9141.045836] Process kswapd0 (pid: 42, ti=f633e000 task=f6331920 task.ti=f633e000)
[ 9141.045838] Stack:
[ 9141.045839]  002889e6 00000000 f6331920 c04462a2 f633feb8 f633feb8 c0beba54 c0bead00
[ 9141.045844]  00000003 f633ff68 c04b3ffb 00000002 00000000 000086d1 f6331920 f633ff58
[ 9141.045849]  00000000 f6331920 00037b92 00000000 00000045 00000000 00000038 00000001
[ 9141.045854] Call Trace:
[ 9141.045934]  [<c04462a2>] ? remove_wait_queue+0x27/0x27
[ 9141.045939]  [<c04b3ffb>] kswapd+0x5ef/0x705
[ 9141.045942]  [<c04462a2>] ? remove_wait_queue+0x27/0x27
[ 9141.045945]  [<c0445cbc>] kthread+0x6b/0x70
[ 9141.045947]  [<c04b3a0c>] ? shrink_lruvec+0x492/0x492
[ 9141.083149]  [<c0907637>] ret_from_kernel_thread+0x1b/0x28
[ 9141.083166]  [<c0445c51>] ? kthread_freezable_should_stop+0x36/0x36
[ 9141.083169] Code: 89 45 dc 31 c0 f3 ab 64 a1 58 66 c7 c0 89 45 e4 8d 45 ec 89 45 ec 89 45 f0 8b 04 95 24 2b cf c0 c7 45 e8 a2 62 44 c0 85 c0 74 0a <8b> 83 80 02 00 00 a8 04 75 1b e8 e9 6f 44 00 a1 40 9a b8 c0 8b
[ 9141.089753] EIP: [<c04ba69c>] wait_iff_congested+0x45/0xdd SS:ESP 0068:f633fea8
[ 9141.089764] CR2: 0000000000000280
[ 9141.090296] ---[ end trace 58a34900f079b57e ]---
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
