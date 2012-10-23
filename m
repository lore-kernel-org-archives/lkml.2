Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2JWFjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:39:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37192 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2JWFi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:38:59 -0400
X-AuditID: cbfee611-b7fa86d0000010a9-33-50862d71dcae
Date: Tue, 23 Oct 2012 05:38:57 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: 3.7-rc2 regression : file copied to CIFS-mounted directory
 corrupted
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
Cc: Jongman Heo <jongman.heo@samsung.com>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20121023052818668@jongman.heo
Msgkey: 20121023052818668@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPHeader: ML
X-RootMTR: 20121023032623567@jongman.heo
X-ParentMTR: 20121023032623567@jongman.heo
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <22207427.56211350970373630.JavaMail.weblogic@epml04>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t8zHd1C3bYAg41PuSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzQuPmArWGVWsmL6NvYGxxbCLkZNDSEBN4ubnQ4wgtoSAicTe
	ljUsELaYxIV769m6GLmAamYxSvRPPcEMU/TrwXeoxHxGicddD5lAEiwCqhK7Pr5gB7HZBHQk
	Ov7vZ+1i5OAQFgiU2Ps4FaReRGApo8Shu+/AtjELaEtcX3yfCeIKRYlrSxezgdi8AoISJ2c+
	YQHplRBQkdj7zQEirCrxYOtrqBvEJS7MvcQOYfNKzGh/CnW0nMS0r2ugaqQlzs/aAPUYv8Sx
	2zuYIGxNie2zlkPZ2hKHP71jganZdWo5M8zM+1vmMkGcqSgxpfshO8g5zEC963fpo7oSxHaU
	OLpuPwskFAQkvk0+xALyroTAX3aJ6Q2ToHZJShxccYNlAqP8LCT9s5CsmIWwAlnJAkaWVYyi
	qQXJBcVJ6anmesWJucWleel6yfm5mxgh8S+4g3Fpg8UhRgEORiUeXosjrQFCrIllxZW5hxgl
	OJiVRHiVA4BCvCmJlVWpRfnxRaU5qcWHGH2Arp3ILCWanA9MTXkl8YbGBsaGhpaGZqaWpgY4
	hJXEecs9UgKEBNITS1KzU1MLUotgxjFxcEo1MDKt+lGja733e9q6GNG1qbnTnjaa5+44UnDn
	ddxLFVftF6lHp2vyXzoad3uuf0qDUY1m7u6nlyvmHWyY6Fq5LfOG0JRLW5PX2qlWfAy6NOtC
	/qEykS7taRYvH7A1um79lfu3q9FX6rjc2VsHP2z89XXdvaupR4TO/C1olTgYbeYju5Hhgmbq
	lbNKLMUZiYZazEXFiQCsEJX+LAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t/tGbqFum0BBg92sFlc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jJsXHjEVrDOqWDF9G3sDY4thFyMnh5CAmsTNz4cYQWwJAROJXw++s0HYYhIX7q0HsrmAauYz
	SjzuesgEkmARUJXY9fEFO4jNJqAj0fF/P2sXIweHsECgxN7HqSD1IgJLGSUO3X0HNpRZQFvi
	+uL7TBDLFCWuLV0MtoBXQFDi5MwnLCC9EgIqEnu/OUCEVSUebH3NDHGDuMSFuZfYIWxeiRnt
	T1kgbDmJaV/XQNVIS5yftQHqfn6JY7d3MEHYmhLbZy2HsrUlDn96xwJTs+vUcmaYmfe3zGWC
	OFNRYkr3Q3aQc5iBetfv0kd1JYjtKHF03X6WCYxSs5CkZiHpnoXQjaxkASPLKkbR1ILkguKk
	9FRzveLE3OLSvHS95PzcTYzg9PFMcAfj0gaLQ4wCHIxKPLwWR1oDhFgTy4orcw8xSnAwK4nw
	KgcAhXhTEiurUovy44tKc1KLDzH6AKNjIrOUaHI+MLXllcQbGhsYGxpamhuYGhpZ4BBWEuct
	90gJEBJITyxJzU5NLUgtghnHxMEp1cBos7BIYn+rWke/SlbG7hvKX58cjv3ZMeX+vTDlm3Hv
	1nDxHVvH4nO9oTQ3iTl0EU85023tC17yDNuU/u7KE/55eaPZ/Lof71TNXa8lLz8bZHVymtXl
	g9mWxRO2P1+Q7l1+mfGqsendOK8akV3t+wyVzb+2bXtmtqJPhee6YpxlcZXuzdi7ZcuUWIoz
	Eg21mIuKEwE0uYrkTAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9N5d6GI001211


Hmm,

I've just met the issue, with the commit 5640f768 reverted.
It seems that the issue does not always happen. So, my bisection may not be correct.

At this moment, I don't have enough time to do bisection again..

Regards.

[sorry for top posting, our corporate MTA is not good at e-mail writing for mailing list... ]

------- Original Message -------
Sender : Jongman Heo<jongman.heo@samsung.com>
Date : 2012-10-23 12:30 (GMT+09:00)
Title : 3.7-rc2 regression : file copied to CIFS-mounted directory corrupted


Hi, all,

With 3.7-rc2, I noticed that file copied to CIFS-mounted directory is corrupted. 
Integrity is checked by md5sum.

  1. get md5sum of file located on local (ext4) disk
  2. copy the file to CIFS-mounted directory
  3. check md5sum of the copied file

Host   : Windows 7
Guest : Fedora 16 on VMWare
Kernel : 3.7-rc2

Shared directory exists on Windows 7 Host, and Linux Guest on VMware mounts it using CIFS.

I thought it was related to CIFS or VFS changes, but it wasn't.

Below is a git bisect log, and first bad commit is 5640f768, "net: use a per task frag allocator".

Reverting the commit 5640f768 fixes the corruption issue on CIFS directory.
During revert, I got conflict in net/ipv4/raw.c. I took "parent of 5640f76" hunk to resolve it.

# git bisect log
git bisect start
# bad: [6f0c0580b70c89094b3422ba81118c7b959c7556] Linux 3.7-rc2
git bisect bad 6f0c0580b70c89094b3422ba81118c7b959c7556
# good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
git bisect good a0d271cbfed1dd50278c6b06bead3d00ba0a88f9
# good: [fec344e3f31aa911297cd3a4639432d983b1f324] cifs: change cifs_call_async to use smb_rqst structs
git bisect good fec344e3f31aa911297cd3a4639432d983b1f324
# good: [3d6d854a13844223b603fd7a16a4a4a4afd62c72] cifs: add FL_CLOSE to fl_flags mask in cifs_read_flock
git bisect good 3d6d854a13844223b603fd7a16a4a4a4afd62c72
# good: [f065fd099fc475333fc7a55677a7f64764445d55] CIFS: Fix possible freed pointer dereference in CIFS_SessSetup
git bisect good f065fd099fc475333fc7a55677a7f64764445d55
# bad: [b7a10626c8bc88fd097a8bb4486c89558f89320c] [CIFS] WARN_ON_ONCE if kernel_sendmsg() returns -ENOSPC
git bisect bad b7a10626c8bc88fd097a8bb4486c89558f89320c
# good: [1d4ab9077681b7cce60ff46e3a42fe2dafa0b83d] [CIFS] Fix indentation of fs/cifs/Kconfig entries
git bisect good 1d4ab9077681b7cce60ff46e3a42fe2dafa0b83d
# bad: [aab174f0df5d72d31caccf281af5f614fa254578] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad aab174f0df5d72d31caccf281af5f614fa254578
# good: [d9a807461fc8cc0d6ba589ea0730d139122af012] Merge tag 'usb-3.6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect good d9a807461fc8cc0d6ba589ea0730d139122af012
# good: [a20acf99f75e49271381d65db097c9763060a1e8] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next
git bisect good a20acf99f75e49271381d65db097c9763060a1e8
# bad: [d379142bc4d9b78cdd9fc5aa696ca1ea083fb7d4] be2net: fixup log messages
git bisect bad d379142bc4d9b78cdd9fc5aa696ca1ea083fb7d4
# good: [2a35cfa591ac63f17815c2d9432b799e37527980] r8169: add D-Link DGE-560T identifiers.
git bisect good 2a35cfa591ac63f17815c2d9432b799e37527980
# good: [9316f0e3c6ba524d8fa14bfded048b252891931a] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next into for-davem
git bisect good 9316f0e3c6ba524d8fa14bfded048b252891931a
# good: [623df484a777f3c00c1ea3d6a7565b8d8ac688a1] tcp: extract code to compute SYNACK RTT
git bisect good 623df484a777f3c00c1ea3d6a7565b8d8ac688a1
# bad: [c523530ce17defe6b28ccfe622c506488f430866] can: c_can: fix segfault during rmmod
git bisect bad c523530ce17defe6b28ccfe622c506488f430866
# good: [6ee584be3ee30f72dec8a8ca87bc10824e27a631] netfilter: nfnetlink_queue: add NFQA_CAP_LEN attribute
git bisect good 6ee584be3ee30f72dec8a8ca87bc10824e27a631
# good: [725b9c0425f54450d1f376befb85dae706ea0c7a] qeth: cleanup channel path descriptor function
git bisect good 725b9c0425f54450d1f376befb85dae706ea0c7a
# good: [0cf833aefaa85bbfce3ff70485e5534e09254773] net: loopback: set default mtu to 64K
git bisect good 0cf833aefaa85bbfce3ff70485e5534e09254773
# bad: [9e49e88958feb41ec701fa34b44723dabadbc28c] filter: add XOR instruction for use with X/K
git bisect bad 9e49e88958feb41ec701fa34b44723dabadbc28c
# bad: [5640f7685831e088fe6c2e1f863a6805962f8e81] net: use a per task frag allocator
git bisect bad 5640f7685831e088fe6c2e1f863a6805962f8e81
# good: [b98b8babd6e3370fadb7c6eaacb00eb2f6344a6c] gianfar: Change default HW Tx queue scheduling mode
git bisect good b98b8babd6e3370fadb7c6eaacb00eb2f6344a6c

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
