Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3ADA5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:57:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24282 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3ADA5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:57:42 -0500
X-AuditID: cbfee60e-b7f456d000003bef-21-50e62904626a
Date: Fri, 04 Jan 2013 00:57:40 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: [3.8-rc2] stuck at reading CIFS mounted directory
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20130104005201938@jongman.heo
Msgkey: 20130104005201938@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130104005201938@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1839076.322591357261060518.JavaMail.weblogic@epml11>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t8zLV0WzWcBBj1P9Cwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGwh2nmQr2yFe8ftHD1sB4Qa6LkZNDSEBN4ubnQ4wgtoSAicS7
	S13MELaYxIV769m6GLmAapYxSpy/eY8Zpmj2ou9MEIn5jBJTNnWydjFycLAIqEjMeOEPUsMm
	oCPR8X8/K4gtLGAlcWbScbAFIgKOEjsOfmWDWKwocW3pYjCbV0BQ4uTMJywgYySAxhw/JQYR
	VpV4sOMXG8RacYkLcy+xQ9i8EjPan7JA2HIS076ugTpNWuL8rA2MMPcv/v4YKs4vcez2DiaI
	8bwST+4Hw4zZvfkL1HgBialnDjJClGhKvFknDRHmk1iz8C0LzJRdp5Yzw7Te3zKXCcRmBnpk
	SvdDdpBWZqDW9bv0Uf0EYjtKzPp9FBweLECbvk0+xDKBUWkWkrJZSCbNQpiErGQBI8sqRtHU
	guSC4qT0VBO94sTc4tK8dL3k/NxNjJB0wLeDcV6DxSFGAQ5GJR5eiztPA4RYE8uKK3MPMUpw
	MCuJ8L67DRTiTUmsrEotyo8vKs1JLT7E6AN01ERmKdHkfGCqyiuJNzQ2MDY0tDQ0M7U0NcAh
	rCTOq1QxPUBIID2xJDU7NbUgtQhmHBMHp1QDo637aWb7LYfzFn9xXHsjUiv115rk1zX3J0Sy
	ufP8qj2gdSDurcOH59qHm89J9TbdbSrRUTvmK/1x64sE7+2r/18OktqX8trm+ctz/gqvM7k6
	WZrYihNklN93RTznrHt0Vmlis5+tBXdcvRJXS9cyJv4Ppxtm/HFItjq6fWFxXAx7+YajwRFm
	SizFGYmGWsxFxYkASNEnPTQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t/tGbosms8CDA5M0rS4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GQt3nGYq2CNf8fpFD1sD4wW5LkZODiEBNYmbnw8xgtgSAiYSsxd9Z4KwxSQu3FvP1sXIBVQz
	n1FiyqZO1i5GDg4WARWJGS/8QWrYBHQkOv7vZwWxhQWsJM5MOg42R0TAUWLHwa9sEPMVJa4t
	XQxm8woISpyc+YQFZIwE0Jjjp8QgwqoSD3b8YoNYKy5xYe4ldgibV2JG+1MWCFtOYtrXNcwQ
	trTE+VkbGGHOXPz9MVScX+LY7R1MEON5JZ7cD4YZs3vzF6jxAhJTzxxkhCjRlHizThoizCex
	ZuFbFpgpu04tZ4Zpvb9lLjhAmIEemdL9kB2klRmodf0ufVQ/gdiOErN+H2WdwCg7C0lqFpLu
	WQjdyEoWMLKsYhRNLUguKE5KTzXRK07MLS7NS9dLzs/dxAhOQM/4djDOa7A4xCjAwajEw2tx
	52mAEGtiWXFl7iFGCQ5mJRHed7eBQrwpiZVVqUX58UWlOanFhxh9gPE1kVlKNDkfmBzzSuIN
	jQ2MDQ0tzQ1MDY0scAgrifMqVUwPEBJITyxJzU5NLUgtghnHxMEp1cDYXP96/tZf8T4l5/JF
	WIyjZt3fF5QhsUT4pHbbpvT8uYecuBpeBhy0v8HAVm7AldP+9AD7r1s6Ogs0rqo6Jvz9eoZn
	0yErzpg/PyZyfHs9kXfZmayuKVW7g2ctleY9Ir3h4+WUDdcMSuf/eb+QfdOrhLJ9J3Zs/rFt
	geXJu0psDRd859ma8XM7KbEUZyQaajEXFScCAKe/GUttAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r040vjME012716

Hi, all,

In 3.8-rc2, access to CIFS-mounted directory (df, ls, or similar) got stuck with following message.

It's mounted with...
  mount -t cifs //<win_host_ip_address>/Share  /mnt/window -o user=jongman.heo,password=xxxx,sec=ntlm


[16655.288591] INFO: task bash:4042 blocked for more than 120 seconds.
[16655.318117] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[16655.318123] bash            D dada9c5c     0  4042      1 0x00000004
[16655.318132]  dada9cd0 00000082 00000282 dada9c5c c09022c6 dada9c7c c044d316 c0c7c300
[16655.318139]  d6db3a7b 00000f09 c0c7c300 00000000 00000f09 f3b7b240 c04401ba 00000000
[16655.318145]  c0b9e0d8 f598e960 00000000 00000303 dada9c98 dada9c98 f598e960 00000006
[16655.318150] Call Trace:
[16655.342785]  [<c09022c6>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[16655.351554]  [<c044d316>] ? __wake_up+0x3b/0x42
[16655.358802]  [<c04401ba>] ? call_usermodehelper_fns+0x148/0x152
[16655.358840]  [<c0440468>] ? __request_module+0x15e/0x1a1
[16655.358842]  [<c043fe3d>] ? call_usermodehelper_freeinfo+0x19/0x19
[16655.358845]  [<c0901a9a>] schedule+0x51/0x53
[16655.358847]  [<c0901bed>] schedule_preempt_disabled+0x8/0xa
[16655.384345]  [<c0900de6>] __mutex_lock_common+0xd6/0x123
[16655.384430]  [<c0900f39>] __mutex_lock_slowpath+0x20/0x22
[16655.384436]  [<c0900edf>] ? mutex_lock+0x18/0x25
[16655.384441]  [<c0900edf>] mutex_lock+0x18/0x25
[16655.384892]  [<c05e1650>] cifs_reconnect_tcon+0x170/0x252
[16655.384953]  [<c044c652>] ? should_resched+0x8/0x22
[16655.384963]  [<c09018dc>] ? _cond_resched+0x8/0x1c
[16655.384969]  [<c05e174f>] smb_init+0x1d/0x6d
[16655.385023]  [<c05e4f7f>] CIFSSMBQPathInfo+0x4e/0x1e4
[16655.385071]  [<c05fe062>] cifs_query_path_info+0x38/0x73
[16655.385080]  [<c05f460a>] cifs_get_inode_info+0x122/0x3ac
[16655.385548]  [<c04e1f2f>] ? walk_component+0x14a/0x17a
[16655.385570]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
[16655.385585]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
[16655.385596]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
[16655.385601]  [<c04e225c>] ? getname_flags+0x59/0xeb
[16655.385606]  [<c090227a>] ? _raw_spin_lock+0x8/0xa
[16655.385613]  [<c05f5c84>] cifs_revalidate_dentry_attr+0x120/0x168
[16655.385618]  [<c05f5d6d>] cifs_getattr+0x5e/0xe3
[16655.385625]  [<c04dde86>] vfs_getattr+0x37/0x4e
[16655.385631]  [<c05f5d0f>] ? cifs_revalidate_dentry+0x20/0x20
[16655.385639]  [<c04ddef6>] vfs_fstatat+0x59/0x8a
[16655.385645]  [<c04ddf5b>] vfs_stat+0x19/0x1b
[16655.385652]  [<c04de160>] sys_stat64+0x11/0x22
[16655.385659]  [<c044c652>] ? should_resched+0x8/0x22
[16655.385668]  [<c09018dc>] ? _cond_resched+0x8/0x1c
[16655.385674]  [<c0443b74>] ? task_work_run+0x6d/0x79
[16655.385825]  [<c0904f3d>] ? __do_page_fault+0x33b/0x33b
[16655.385834]  [<c0904f45>] ? do_page_fault+0x8/0xa
[16655.385840]  [<c0907911>] sysenter_do_call+0x12/0x2c

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
