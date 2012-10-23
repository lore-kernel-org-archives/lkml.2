Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2JWDaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:30:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16767 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2JWDaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:30:07 -0400
X-AuditID: cbfee60b-b7fdb6d0000002b7-a0-50860f3d3508
Date: Tue, 23 Oct 2012 03:30:05 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: 3.7-rc2 regression : file copied to CIFS-mounted directory corrupted
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, edumazet@google.com
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20121023032623567@jongman.heo
Msgkey: 20121023032623567@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121023032623567@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <30635893.51501350963005670.JavaMail.weblogic@epml04>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zPV1b/rYAg87bphaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj09N7jAVXdCr63pxib2Dco93FyMkhJKAmcfPzIUYQW0LARGL1
	i14oW0ziwr31bF2MXEA1yxglpt/5wwRTtKplORNEYj6jxJX9W5hBEiwCqhILOiezg9hsAjoS
	Hf/3s4LYwgK+Es0tP8GaRQQSJM5Of84KsVlR4trSxWwgNq+AoMTJmU9YIBaoSPzb2w80kwMo
	rirxsikDIiwucWHuJXYIm1diRvtTqHI5iWlf1zBD2NIS52dtgHtg8ffHUHF+iWO3dzCBjATp
	fXI/GGbM7s1f2CBsAYmpZw5CtWpKbJ+1HOpdPok1C9+ywIzZdWo5M0zv/S1zwWqYgT6Z0v2Q
	HWQ8M1Dv+l366J7iFXCU6O6czQQJKAGJb5MPsUxgVJqFpGwWkkmzECYhK1nAyLKKUTS1ILmg
	OCk91VCvODG3uDQvXS85P3cTIyQlcO9gnNVgcYhRgINRiYfX4khrgBBrYllxZe4hRgkOZiUR
	XuUAoBBvSmJlVWpRfnxRaU5q8SFGH6CjJjJLiSbnA9NVXkm8obGBsaGhpaGZqaWpAQ5hJXHe
	Oo+UACGB9MSS1OzU1ILUIphxTBycUg2MPJ8bPdVXZc56vO1GvomZVfLRtY9SFknNr1mm0+AQ
	+ubdtIPalle2Zydergx0ja5mFzt55FJd8dRr66fmXeFLavjxKG4n77ml6mc1apZUFpQU9rYa
	2Mokn1kf6cLEndf53fAXA+9L6+Tg20LO859P/q/t8cRth/CG0mXK3zLfRr2e+0Dmo0yoEktx
	RqKhFnNRcSIAuXB/qzYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t/tGbq2/G0BBp3rDC0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xqen9xgLruhU9L05xd7AuEe7i5GTQ0hATeLm50OMILaEgInEqpblTBC2mMSFe+vZuhi5gGrm
	M0pc2b+FGSTBIqAqsaBzMjuIzSagI9Hxfz8riC0s4CvR3PITrFlEIEHi7PTnrBALFCWuLV3M
	BmLzCghKnJz5hAVigYrEv739QDM5gOKqEi+bMiDC4hIX5l5ih7B5JWa0P4Uql5OY9nUNM4Qt
	LXF+1gZGmDsXf38MFeeXOHZ7BxPISJDeJ/eDYcbs3vyFDcIWkJh65iBUq6bE9lkw7/JJrFn4
	lgVmzK5Ty5lheu9vmQtWwwz0yZTuh+wg45mBetfv0kf3FK+Ao0R352ymCYyys5CkZiHpnoXQ
	jaxkASPLKkbR1ILkguKk9FRDveLE3OLSvHS95PzcTYzgJPSMewfjrAaLQ4wCHIxKPLwWR1oD
	hFgTy4orcw8xSnAwK4nwKgcAhXhTEiurUovy44tKc1KLDzH6AGNsIrOUaHI+MEHmlcQbGhsY
	GxpamhuYGhpZ4BBWEuet80gJEBJITyxJzU5NLUgtghnHxMEp1cC48tIqI5HJm+ymN1Su+3hx
	qhYwTDlecij2vH707srhIy9kMgLnVp+9/qZVYx/PrB3W7xQf6Lw7qW788qL0h9g+rUMRYq4t
	rGI3lppVXTx594Dz+SvPStk7d/230z9j4Fyy+TrrlHPfO6IsLHea5H6RvTV32wFb67Nb3+9a
	ojZ5hq7wI7ep/t9/KLEUZyQaajEXFScCAGr4tYhvAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9N3UWcv000778


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
