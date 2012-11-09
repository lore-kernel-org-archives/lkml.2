Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2KICTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:19:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41690 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2KICTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:19:35 -0500
X-AuditID: cbfee60e-b7f8e6d0000072f3-64-509c68353c84
Date: Fri, 09 Nov 2012 02:19:33 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: How to debug system freeze  (not detected by kernel debug options)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20121109021300301@jongman.heo
Msgkey: 20121109021300301@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121024024610830@jongman.heo
X-ParentMTR: 20121029053525306@jongman.heo
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <574089.21861352427573311.JavaMail.weblogic@epml01>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t8zTV3TjDkBBvtuyFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MWXNPMRccYq/Y8fIEYwPjEvYuRk4OIQE1iZufDzGC2BICJhJX
	Zp1lhbDFJC7cW88GUbOMUaL/rUcXIwdYTd9B7y5GLqDwfEaJFb9WsYDUsAioSNxZsoAZxGYT
	0JHo+L8fbI6wgLfEscnXwXaJCDhK7Dj4FWqmosS1pYvBbF4BQYmTM5+wQOxVkZg7/Q0byC5e
	AVWJ3wtcIcLiEhfmXmKHsHklZrQ/hSqXk5j2dQ0zhC0tcX7WBkaY8xd/fwwV55c4dnsHE8T5
	vBJP7gfDjNm9+QsbhC0gMfXMQahWTYn2k8egWrUlVt26yQYzZtep5cwwvfe3zGUCsZmBPpnS
	/ZAdZDwzUO/6XfronuIVsJfYv/ABMySgBCS+TT7EMoFRaRaSsllIJs1CmISsZAEjyypG0dSC
	5ILipPRUE73ixNzi0rx0veT83E2MkHTAt4NxXoPFIUYBDkYlHt7EB7MDhFgTy4orcw8xSnAw
	K4nw1jHNCRDiTUmsrEotyo8vKs1JLT7E6AN01ERmKdHkfGCqyiuJNzQ2MDY0tDQ0M7U0NcAh
	rCTOq1QxPUBIID2xJDU7NbUgtQhmHBMHp1QDo+a+yRn76rbIzdj889Gr8Fe7Lrx1vfDqX+9D
	OcXnpYsETqn+O7vwS81fs9hvE3eYl9SVnnK5XNs01fKQ+fNyxfAq5XoLy/Nlh/+yfzG7b/vh
	wImQ3U8PHHbN4jm3w+ISm7iaWLAJo+Lji7VCihmsUU/iOoujdRdEKs878db33sNLqlJhk3Y9
	KlRiKc5INNRiLipOBAAXQm35NAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t/tGbqmGXMCDDbvlba4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GbPmnmIuOMResePlCcYGxiXsXYycHEICahI3Px9i7GLk4JAQMJHoO+gNEpYQEJO4cG89Wxcj
	F1DJfEaJFb9WsYAkWARUJO4sWcAMYrMJ6Eh0/N/PCmILC3hLHJt8HWymiICjxI6DX9kg5itK
	XFu6GMzmFRCUODnzCQvEAhWJudPfsIHs5RVQlfi9wBUiLC5xYe4ldgibV2JG+1OocjmJaV/X
	MEPY0hLnZ21ghLlz8ffHUHF+iWO3dzBBvMIr8eR+MMyY3Zu/sEHYAhJTzxyEatWUaD95DKpV
	W2LVrZtsMGN2nVrODNN7f8tcJhCbGeiTKd0P2UHGMwP1rt+lj+4pXgF7if0LHzBPYJSdhSQ1
	C0n3LIRuZCULGFlWMYqmFiQXFCelp5roFSfmFpfmpesl5+duYgSnoGd8OxjnNVgcYhTgYFTi
	4U18MDtAiDWxrLgy9xCjBAezkghvHdOcACHelMTKqtSi/Pii0pzU4kOMPsAYm8gsJZqcD0yP
	eSXxhsYGxoaGluYGpoZGFjiElcR5lSqmBwgJpCeWpGanphakFsGMY+LglGpgbLp65cEi/7Ln
	uRffpu9xz123dWXV7i5HyZxrmbsDK57YSS5Se7LS+LrjqWVKzY5ZQSxX5m26c6rVOSv/9FJm
	Yb+p2w7unsjINE146Uf3OaLiftUlJ+Y4V1rNcFTzWKzZKsipM5/5QI2zUPPvTa13Kqp2WoS2
	LnLwtnSP2OYutSmlk6/87+OfSizFGYmGWsxFxYkAmy6NDW4DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA92JfXY028947


Dear kernel hackers,

I have a problem in SMP environment, in x86 platform (Intel Atom based embedded system)

In UP, there is no issue, but in SMP, system freezed in tens of minutes (or shorter), if I perform IO test with flash memory and HDD simultaneously (using dd).

I enabled relevant kernel debug options, like LOCKDEP, DETECT_SOFTLOCKUP, DETECT_HUNG_TASK, along with "nmi_watchdog=1".
(Yeah, this is somewhat old kernel, 2.6.35.14).

But no debug message is shown. (I had checked that NMI interrupt count correctly increase.).

Do you have any thoughts what can cause system freeze without being detected by LOCKDEP, watchdog, and other options.

Thanks in advance,
Jongman.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
