Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3AIDRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 22:17:45 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48404 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab3AIDRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 22:17:43 -0500
X-AuditID: cbfee612-b7f686d0000028ad-5a-50ece1552e10
Date: Wed, 09 Jan 2013 03:17:41 +0000 (GMT)
From: =?euc-kr?B?x+PBvri4?= <jongman.heo@samsung.com>
Subject: Re: Re: [3.8-rc2] stuck at reading CIFS mounted directory
To: Jeff Layton <jlayton@redhat.com>, Suresh Jayaraman <sjayaraman@suse.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20130109030241847@jongman.heo
Msgkey: 20130109030241847@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130109030241847@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <16401870.457771357701460059.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t8zbd3Qh28CDJb8krS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZRw7uYir49IKxYur/A8wNjB8eMXYxcnIICahJ3Px8CMyWEDCR
	mNs8hQ3CFpO4cG89kM0FVLOMUeJnbwsbTFHbqTZmiMR8RomJm7rAulkEVCRu7bwCVsQmYCZx
	7PxvsLiwgJPElznfmUBsEYEgiWsP1gDZHBzMAnkS+55JQByhKHFt6WKwVl4BQYmTM5+wgJRI
	AI28ssoIIqwq0bH6FdSdEhKzpl9ghbB5JWa0P2WBsOUkpn1dwwxhS0ucn7WBEeaXxd8fQ8X5
	JY7d3sEEMZ5X4sn9YJgxuzd/gfpQQGLqmYNQrZoSXya9h4rzSaxZ+JYFZsyuU8uZYXrvb5kL
	9iAz0CdTuh+yQ9haEl9+7EPzFYjtJLHm+SO2CYzKs5CkZiFpn4WkHVnNAkaWVYyiqQXJBcVJ
	6akWesWJucWleel6yfm5mxghiUFoB+OyBotDjAIcjEo8vA+mvQkQYk0sK67MPcQowcGsJMJ7
	1xsoxJuSWFmVWpQfX1Sak1p8iDEZGH0TmaVEk/OBSSuvJN7Q2MDY0NDS0MzU0tSANGElcV7O
	iukBQgLpiSWp2ampBalFMFuYODilGhj96l8Zzf+6f77G3r3TLe/nSB1+GLfgNYfabMad0gKP
	tBtn7NNyP/Txg++Njpbyr2YW65p/bq2xMd+tmLHgz/IYt17+16KtPyXMsm1FKpZv4jgjssH4
	6zlTxayfhkZNjje7zqvOe/WY3UWn/N1eiWsBwbEJR/myRFaH/N5bqJPit1T0zGbtQzlKLMUZ
	iYZazEXFiQAh5VaLUAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2dN3Qh28CDJa8ErS4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GUcO7mIq+PSCsWLq/wPMDYwfHjF2MXJyCAmoSdz8fAjMlhAwkWg71cYMYYtJXLi3nq2LkQuo
	Zj6jxMRNXWBFLAIqErd2XmEDsdkEzCSOnf8NFhcWcJL4Muc7E4gtIhAkce3BGiCbg4NZIE9i
	3zMJiF2KEteWLgZr5RUQlDg58wkLSIkE0Mgrq4wgwqoSHatfQZ0jITFr+gVWCJtXYkb7UxYI
	W05i2tc1UGdKS5yftYER5uTF3x9Dxfkljt3ewQQxnlfiyf1gmDG7N39hg7AFJKaeOQjVqinx
	ZdJ7qDifxJqFb1lgxuw6tZwZpvf+lrlgDzIDfTKl+yE7hK0l8eXHPjRfgdhOEmueP2KbwCg3
	C0lqFpL2WUjakdUsYGRZxSiaWpBcUJyUnmqhV5yYW1yal66XnJ+7iRGcop4J7WBc1mBxiFGA
	g1GJh/fBtDcBQqyJZcWVuYcYJTiYlUR473oDhXhTEiurUovy44tKc1KLDzEmA6NvIrOUaHI+
	MH3mlcQbGhsYGxpamhuYGhpZkCasJM7LWTE9QEggPbEkNTs1tSC1CGYLEwenVANj8LOpoptP
	yCn76gvJK8fbuRixKhRr8kWHLgvds5BH29WsvWG/hppC11s5RnVHy87tKuv4vEqmCK/ztjaN
	WnH4/K+wkukm9779Twu5+LJg35Ydb64WMUvcuix+iuHF9FuBE29zrbb/+V0pXpBzZuDR/Sw5
	jxm9/ravVyi79SiEfdoR3lbWPB8lluKMREMt5qLiRAAEJRuJlQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r093HoG2004211

Hi,

> ------- Original Message -------
> Sender : Jeff Layton<jlayton@redhat.com>
> Date : 2013-01-08 00:13 (GMT+09:00)
> Title : Re: [3.8-rc2] stuck at reading CIFS mounted directory
> 
> On Mon, 07 Jan 2013 15:10:05 +0530
> Suresh Jayaraman wrote:
> 
> > (Cc linux-cifs@vger.kernel.org)
> > 
> > On 01/04/2013 06:27 AM, Jongman Heo wrote:
> > > Hi, all,
> > > 
> > > In 3.8-rc2, access to CIFS-mounted directory (df, ls, or similar) got stuck with following message.
> > > 
> > > It's mounted with...
> > >   mount -t cifs ///Share  /mnt/window -o user=jongman.heo,password=xxxx,sec=ntlm
> > > 
> > > 
> > > [16655.288591] INFO: task bash:4042 blocked for more than 120 seconds.
> > > [16655.318117] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [16655.318123] bash            D dada9c5c     0  4042      1 0x00000004
> > > [16655.318132]  dada9cd0 00000082 00000282 dada9c5c c09022c6 dada9c7c c044d316 c0c7c300
> > > [16655.318139]  d6db3a7b 00000f09 c0c7c300 00000000 00000f09 f3b7b240 c04401ba 00000000
> > > [16655.318145]  c0b9e0d8 f598e960 00000000 00000303 dada9c98 dada9c98 f598e960 00000006
> > > [16655.318150] Call Trace:
> > > [16655.342785]  [] ? _raw_spin_unlock_irqrestore+0xf/0x11
> > > [16655.351554]  [] ? __wake_up+0x3b/0x42
> > > [16655.358802]  [] ? call_usermodehelper_fns+0x148/0x152
> > > [16655.358840]  [] ? __request_module+0x15e/0x1a1
> > > [16655.358842]  [] ? call_usermodehelper_freeinfo+0x19/0x19
> > > [16655.358845]  [] schedule+0x51/0x53
> > > [16655.358847]  [] schedule_preempt_disabled+0x8/0xa
> > > [16655.384345]  [] __mutex_lock_common+0xd6/0x123
> > > [16655.384430]  [] __mutex_lock_slowpath+0x20/0x22
> > > [16655.384436]  [] ? mutex_lock+0x18/0x25
> > > [16655.384441]  [] mutex_lock+0x18/0x25
> > > [16655.384892]  [] cifs_reconnect_tcon+0x170/0x252
> > > [16655.384953]  [] ? should_resched+0x8/0x22
> > > [16655.384963]  [] ? _cond_resched+0x8/0x1c
> > > [16655.384969]  [] smb_init+0x1d/0x6d
> > > [16655.385023]  [] CIFSSMBQPathInfo+0x4e/0x1e4
> > > [16655.385071]  [] cifs_query_path_info+0x38/0x73
> > > [16655.385080]  [] cifs_get_inode_info+0x122/0x3ac
> > > [16655.385548]  [] ? walk_component+0x14a/0x17a
> > > [16655.385570]  [] ? build_path_from_dentry+0xa3/0x19e
> > > [16655.385585]  [] ? build_path_from_dentry+0xa3/0x19e
> > > [16655.385596]  [] ? build_path_from_dentry+0xa3/0x19e
> > > [16655.385601]  [] ? getname_flags+0x59/0xeb
> > > [16655.385606]  [] ? _raw_spin_lock+0x8/0xa
> > > [16655.385613]  [] cifs_revalidate_dentry_attr+0x120/0x168
> > > [16655.385618]  [] cifs_getattr+0x5e/0xe3
> > > [16655.385625]  [] vfs_getattr+0x37/0x4e
> > > [16655.385631]  [] ? cifs_revalidate_dentry+0x20/0x20
> > > [16655.385639]  [] vfs_fstatat+0x59/0x8a
> > > [16655.385645]  [] vfs_stat+0x19/0x1b
> > > [16655.385652]  [] sys_stat64+0x11/0x22
> > > [16655.385659]  [] ? should_resched+0x8/0x22
> > > [16655.385668]  [] ? _cond_resched+0x8/0x1c
> > > [16655.385674]  [] ? task_work_run+0x6d/0x79
> > > [16655.385825]  [] ? __do_page_fault+0x33b/0x33b
> > > [16655.385834]  [] ? do_page_fault+0x8/0xa
> > > [16655.385840]  [] sysenter_do_call+0x12/0x2c
> > > 
> > > N?????r??y???b?X???v?^?)?{.n?+????{????zX?????}????z?&j:+v???????zZ+??+zf???h???~????i???z??w????????&?)?f??^j?y?m??@A?a??? 0??h??i
> > > 
> > 
> > 
> 
> Looks like it's waiting on the session_mutex to become free. The
> question is what's holding it and why. Some questions:
> 
> 1) is this a regression? If so, what version were you using previously?

Yeah, regression. IIRC I didn't have this issue with 3.7.

> 2) any other processes stuck on on this mutex? What about the cifsd
> thread for this mount? Is it stuck holding it? You may want to
> "cat /proc//stack" on any other threads that might be related here
> and see if you can figure out what they're doing.

After the hang happens, CIFS is working well. Stack of cifsd doesn't show any interesting thing.

[ORANGE@/mnt/window] ps ax | grep cifsd
 1135 ?        S      1:13 [cifsd]
[ORANGE@/mnt/window] cat /proc/1135/stack
[<c0833b8b>] sk_wait_data+0x63/0x9b
[<c0872e20>] tcp_recvmsg+0x3aa/0x780
[<c088cf40>] inet_recvmsg+0x51/0x63
[<c0830628>] sock_recvmsg+0x80/0x9d
[<c0830674>] kernel_recvmsg+0x2f/0x3f
[<c05ea2e9>] cifs_readv_from_socket+0x142/0x1d3
[<c05ea396>] cifs_read_from_socket+0x1c/0x1e
[<c05eaad2>] cifs_demultiplex_thread+0x701/0x72b
[<c0445ca4>] kthread+0x6b/0x70
[<c09078b7>] ret_from_kernel_thread+0x1b/0x28
[<ffffffff>] 0xffffffff


Host : Windows 7
Guest : VMWare Fedora 16 + 3.8 custom kernel

I feel that the issue is more likely to happen in this case.

 mount cifs directory from VMWare guest -> go to S3 sleep mode (by closing lid of laptop) -> open lid -> check cifs directory of VMWare


Following is more call stack trace I hit today.

[23245.542488] INFO: task bash:2711 blocked for more than 120 seconds.
[23245.571664] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23245.571672] bash            D f3bd5c5c     0  2711   2689 0x00000000
[23245.580899]  f3bd5cd0 00000086 00000282 f3bd5c5c c0902306 f3bd5c7c c044d2be c0c7c300
[23245.580910]  b538a613 000014fd c0c7c300 00000000 000014fd f3bf0c90 c0440162 00000000
[23245.580919]  c0b9e0d8 f3b8ab60 00000000 00000303 f3bd5c98 f3bd5c98 f3b8ab60 00000006
[23245.580928] Call Trace:
[23245.603320]  [<c0902306>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[23245.609972]  [<c044d2be>] ? __wake_up+0x3b/0x42
[23245.610114]  [<c0440162>] ? call_usermodehelper_fns+0x148/0x152
[23245.610389]  [<c0440410>] ? __request_module+0x15e/0x1a1
[23245.610397]  [<c043fde5>] ? call_usermodehelper_freeinfo+0x19/0x19
[23245.610404]  [<c0901ada>] schedule+0x51/0x53
[23245.610409]  [<c0901c2d>] schedule_preempt_disabled+0x8/0xa
[23245.610894]  [<c0900e26>] __mutex_lock_common+0xd6/0x123
[23245.610914]  [<c0900f79>] __mutex_lock_slowpath+0x20/0x22
[23245.610920]  [<c0900f1f>] ? mutex_lock+0x18/0x25
[23245.610925]  [<c0900f1f>] mutex_lock+0x18/0x25
[23245.611495]  [<c05e1580>] cifs_reconnect_tcon+0x170/0x252
[23245.611506]  [<c0450644>] ? resched_task+0x5e/0x61
[23245.620010]  [<c05e167f>] smb_init+0x1d/0x6d
[23245.620183]  [<c05e4eaf>] CIFSSMBQPathInfo+0x4e/0x1e4
[23245.620248]  [<c05fdfbc>] cifs_query_path_info+0x38/0x73
[23245.620265]  [<c05f455a>] cifs_get_inode_info+0x122/0x3ac
[23245.620721]  [<c04e1e87>] ? walk_component+0x14a/0x17a
[23245.620736]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23245.620742]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23245.620748]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23245.620754]  [<c04e215c>] ? getname_flags+0x1/0xeb
[23245.620759]  [<c09022ba>] ? _raw_spin_lock+0x8/0xa
[23245.620766]  [<c05f5bd4>] cifs_revalidate_dentry_attr+0x120/0x168
[23245.620772]  [<c05f5cbd>] cifs_getattr+0x5e/0xe3
[23245.620779]  [<c04dda16>] ? cp_new_stat64+0xef/0x101
[23245.620785]  [<c04dddde>] vfs_getattr+0x37/0x4e
[23245.620790]  [<c05f5c5f>] ? cifs_revalidate_dentry+0x20/0x20
[23245.620796]  [<c04dde4e>] vfs_fstatat+0x59/0x8a
[23245.620816]  [<c04ddeb3>] vfs_stat+0x19/0x1b
[23245.620828]  [<c04de0b8>] sys_stat64+0x11/0x22
[23245.620887]  [<c0907951>] sysenter_do_call+0x12/0x2c
[23365.425634] INFO: task bash:2711 blocked for more than 120 seconds.
[23365.425642] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23365.425645] bash            D f3bd5c5c     0  2711   2689 0x00000000
[23365.425653]  f3bd5cd0 00000086 00000282 f3bd5c5c c0902306 f3bd5c7c c044d2be c0c7c300
[23365.425663]  b538a613 000014fd c0c7c300 00000000 000014fd f3bf0c90 c0440162 00000000
[23365.425672]  c0b9e0d8 f3b8ab60 00000000 00000303 f3bd5c98 f3bd5c98 f3b8ab60 00000006
[23365.425681] Call Trace:
[23365.425696]  [<c0902306>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[23365.425704]  [<c044d2be>] ? __wake_up+0x3b/0x42
[23365.425711]  [<c0440162>] ? call_usermodehelper_fns+0x148/0x152
[23365.425717]  [<c0440410>] ? __request_module+0x15e/0x1a1
[23365.425723]  [<c043fde5>] ? call_usermodehelper_freeinfo+0x19/0x19
[23365.425728]  [<c0901ada>] schedule+0x51/0x53
[23365.425732]  [<c0901c2d>] schedule_preempt_disabled+0x8/0xa
[23365.425740]  [<c0900e26>] __mutex_lock_common+0xd6/0x123
[23365.425746]  [<c0900f79>] __mutex_lock_slowpath+0x20/0x22
[23365.425751]  [<c0900f1f>] ? mutex_lock+0x18/0x25
[23365.425757]  [<c0900f1f>] mutex_lock+0x18/0x25
[23365.425765]  [<c05e1580>] cifs_reconnect_tcon+0x170/0x252
[23365.425771]  [<c0450644>] ? resched_task+0x5e/0x61
[23365.425777]  [<c05e167f>] smb_init+0x1d/0x6d
[23365.425782]  [<c05e4eaf>] CIFSSMBQPathInfo+0x4e/0x1e4
[23365.425790]  [<c05fdfbc>] cifs_query_path_info+0x38/0x73
[23365.425796]  [<c05f455a>] cifs_get_inode_info+0x122/0x3ac
[23365.425804]  [<c04e1e87>] ? walk_component+0x14a/0x17a
[23365.425809]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23365.425814]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23365.425819]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23365.425824]  [<c04e215c>] ? getname_flags+0x1/0xeb
[23365.425829]  [<c09022ba>] ? _raw_spin_lock+0x8/0xa
[23365.425835]  [<c05f5bd4>] cifs_revalidate_dentry_attr+0x120/0x168
[23365.425841]  [<c05f5cbd>] cifs_getattr+0x5e/0xe3
[23365.425847]  [<c04dda16>] ? cp_new_stat64+0xef/0x101
[23365.425852]  [<c04dddde>] vfs_getattr+0x37/0x4e
[23365.425857]  [<c05f5c5f>] ? cifs_revalidate_dentry+0x20/0x20
[23365.425863]  [<c04dde4e>] vfs_fstatat+0x59/0x8a
[23365.425868]  [<c04ddeb3>] vfs_stat+0x19/0x1b
[23365.425873]  [<c04de0b8>] sys_stat64+0x11/0x22
[23365.425880]  [<c0907951>] sysenter_do_call+0x12/0x2c
[23485.230971] INFO: task bash:2711 blocked for more than 120 seconds.
[23485.230979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23485.230982] bash            D f3bd5c5c     0  2711   2689 0x00000000
[23485.230990]  f3bd5cd0 00000086 00000282 f3bd5c5c c0902306 f3bd5c7c c044d2be c0c7c300
[23485.231001]  b538a613 000014fd c0c7c300 00000000 000014fd f3bf0c90 c0440162 00000000
[23485.231009]  c0b9e0d8 f3b8ab60 00000000 00000303 f3bd5c98 f3bd5c98 f3b8ab60 00000006
[23485.231019] Call Trace:
[23485.231117]  [<c0902306>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[23485.231128]  [<c044d2be>] ? __wake_up+0x3b/0x42
[23485.231136]  [<c0440162>] ? call_usermodehelper_fns+0x148/0x152
[23485.231142]  [<c0440410>] ? __request_module+0x15e/0x1a1
[23485.231148]  [<c043fde5>] ? call_usermodehelper_freeinfo+0x19/0x19
[23485.231153]  [<c0901ada>] schedule+0x51/0x53
[23485.231158]  [<c0901c2d>] schedule_preempt_disabled+0x8/0xa
[23485.231166]  [<c0900e26>] __mutex_lock_common+0xd6/0x123
[23485.231172]  [<c0900f79>] __mutex_lock_slowpath+0x20/0x22
[23485.231177]  [<c0900f1f>] ? mutex_lock+0x18/0x25
[23485.231183]  [<c0900f1f>] mutex_lock+0x18/0x25
[23485.231192]  [<c05e1580>] cifs_reconnect_tcon+0x170/0x252
[23485.231198]  [<c0450644>] ? resched_task+0x5e/0x61
[23485.231204]  [<c05e167f>] smb_init+0x1d/0x6d
[23485.231209]  [<c05e4eaf>] CIFSSMBQPathInfo+0x4e/0x1e4
[23485.231217]  [<c05fdfbc>] cifs_query_path_info+0x38/0x73
[23485.231223]  [<c05f455a>] cifs_get_inode_info+0x122/0x3ac
[23485.231231]  [<c04e1e87>] ? walk_component+0x14a/0x17a
[23485.231236]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23485.231242]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23485.231247]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23485.231252]  [<c04e215c>] ? getname_flags+0x1/0xeb
[23485.231257]  [<c09022ba>] ? _raw_spin_lock+0x8/0xa
[23485.231263]  [<c05f5bd4>] cifs_revalidate_dentry_attr+0x120/0x168
[23485.231269]  [<c05f5cbd>] cifs_getattr+0x5e/0xe3
[23485.231275]  [<c04dda16>] ? cp_new_stat64+0xef/0x101
[23485.231280]  [<c04dddde>] vfs_getattr+0x37/0x4e
[23485.231286]  [<c05f5c5f>] ? cifs_revalidate_dentry+0x20/0x20
[23485.231291]  [<c04dde4e>] vfs_fstatat+0x59/0x8a
[23485.231297]  [<c04ddeb3>] vfs_stat+0x19/0x1b
[23485.231302]  [<c04de0b8>] sys_stat64+0x11/0x22
[23485.231308]  [<c0907951>] sysenter_do_call+0x12/0x2c
[23605.036526] INFO: task bash:2711 blocked for more than 120 seconds.
[23605.036533] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23605.036537] bash            D f3bd5c5c     0  2711   2689 0x00000000
[23605.036545]  f3bd5cd0 00000086 00000282 f3bd5c5c c0902306 f3bd5c7c c044d2be c0c7c300
[23605.036555]  b538a613 000014fd c0c7c300 00000000 000014fd f3bf0c90 c0440162 00000000
[23605.036564]  c0b9e0d8 f3b8ab60 00000000 00000303 f3bd5c98 f3bd5c98 f3b8ab60 00000006
[23605.036574] Call Trace:
[23605.036588]  [<c0902306>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[23605.036596]  [<c044d2be>] ? __wake_up+0x3b/0x42
[23605.036604]  [<c0440162>] ? call_usermodehelper_fns+0x148/0x152
[23605.036609]  [<c0440410>] ? __request_module+0x15e/0x1a1
[23605.036615]  [<c043fde5>] ? call_usermodehelper_freeinfo+0x19/0x19
[23605.036620]  [<c0901ada>] schedule+0x51/0x53
[23605.036624]  [<c0901c2d>] schedule_preempt_disabled+0x8/0xa
[23605.036632]  [<c0900e26>] __mutex_lock_common+0xd6/0x123
[23605.036638]  [<c0900f79>] __mutex_lock_slowpath+0x20/0x22
[23605.036644]  [<c0900f1f>] ? mutex_lock+0x18/0x25
[23605.036649]  [<c0900f1f>] mutex_lock+0x18/0x25
[23605.036657]  [<c05e1580>] cifs_reconnect_tcon+0x170/0x252
[23605.036664]  [<c0450644>] ? resched_task+0x5e/0x61
[23605.036669]  [<c05e167f>] smb_init+0x1d/0x6d
[23605.036675]  [<c05e4eaf>] CIFSSMBQPathInfo+0x4e/0x1e4
[23605.036682]  [<c05fdfbc>] cifs_query_path_info+0x38/0x73
[23605.036689]  [<c05f455a>] cifs_get_inode_info+0x122/0x3ac
[23605.036696]  [<c04e1e87>] ? walk_component+0x14a/0x17a
[23605.036702]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23605.036707]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23605.036712]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23605.036717]  [<c04e215c>] ? getname_flags+0x1/0xeb
[23605.036721]  [<c09022ba>] ? _raw_spin_lock+0x8/0xa
[23605.036728]  [<c05f5bd4>] cifs_revalidate_dentry_attr+0x120/0x168
[23605.036733]  [<c05f5cbd>] cifs_getattr+0x5e/0xe3
[23605.036740]  [<c04dda16>] ? cp_new_stat64+0xef/0x101
[23605.036745]  [<c04dddde>] vfs_getattr+0x37/0x4e
[23605.036750]  [<c05f5c5f>] ? cifs_revalidate_dentry+0x20/0x20
[23605.036946]  [<c04dde4e>] vfs_fstatat+0x59/0x8a
[23605.037061]  [<c04ddeb3>] vfs_stat+0x19/0x1b
[23605.037067]  [<c04de0b8>] sys_stat64+0x11/0x22
[23605.037074]  [<c0907951>] sysenter_do_call+0x12/0x2c
[23724.844814] INFO: task bash:2711 blocked for more than 120 seconds.
[23724.844826] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23724.844830] bash            D f3bd5c5c     0  2711   2689 0x00000000
[23724.844838]  f3bd5cd0 00000086 00000282 f3bd5c5c c0902306 f3bd5c7c c044d2be c0c7c300
[23724.844849]  b538a613 000014fd c0c7c300 00000000 000014fd f3bf0c90 c0440162 00000000
[23724.844857]  c0b9e0d8 f3b8ab60 00000000 00000303 f3bd5c98 f3bd5c98 f3b8ab60 00000006
[23724.844866] Call Trace:
[23724.844881]  [<c0902306>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[23724.844889]  [<c044d2be>] ? __wake_up+0x3b/0x42
[23724.844897]  [<c0440162>] ? call_usermodehelper_fns+0x148/0x152
[23724.844903]  [<c0440410>] ? __request_module+0x15e/0x1a1
[23724.844908]  [<c043fde5>] ? call_usermodehelper_freeinfo+0x19/0x19
[23724.844913]  [<c0901ada>] schedule+0x51/0x53
[23724.844918]  [<c0901c2d>] schedule_preempt_disabled+0x8/0xa
[23724.844926]  [<c0900e26>] __mutex_lock_common+0xd6/0x123
[23724.844932]  [<c0900f79>] __mutex_lock_slowpath+0x20/0x22
[23724.844937]  [<c0900f1f>] ? mutex_lock+0x18/0x25
[23724.844942]  [<c0900f1f>] mutex_lock+0x18/0x25
[23724.844951]  [<c05e1580>] cifs_reconnect_tcon+0x170/0x252
[23724.844957]  [<c0450644>] ? resched_task+0x5e/0x61
[23724.844963]  [<c05e167f>] smb_init+0x1d/0x6d
[23724.844968]  [<c05e4eaf>] CIFSSMBQPathInfo+0x4e/0x1e4
[23724.844976]  [<c05fdfbc>] cifs_query_path_info+0x38/0x73
[23724.844982]  [<c05f455a>] cifs_get_inode_info+0x122/0x3ac
[23724.844990]  [<c04e1e87>] ? walk_component+0x14a/0x17a
[23724.844995]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23724.845000]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23724.845005]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23724.845010]  [<c04e215c>] ? getname_flags+0x1/0xeb
[23724.845015]  [<c09022ba>] ? _raw_spin_lock+0x8/0xa
[23724.845021]  [<c05f5bd4>] cifs_revalidate_dentry_attr+0x120/0x168
[23724.845027]  [<c05f5cbd>] cifs_getattr+0x5e/0xe3
[23724.845033]  [<c04dda16>] ? cp_new_stat64+0xef/0x101
[23724.845038]  [<c04dddde>] vfs_getattr+0x37/0x4e
[23724.845043]  [<c05f5c5f>] ? cifs_revalidate_dentry+0x20/0x20
[23724.845048]  [<c04dde4e>] vfs_fstatat+0x59/0x8a
[23724.845054]  [<c04ddeb3>] vfs_stat+0x19/0x1b
[23724.845059]  [<c04de0b8>] sys_stat64+0x11/0x22
[23724.845066]  [<c0907951>] sysenter_do_call+0x12/0x2c
[23844.651044] INFO: task bash:2711 blocked for more than 120 seconds.
[23844.651052] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23844.651056] bash            D f3bd5c5c     0  2711   2689 0x00000000
[23844.651063]  f3bd5cd0 00000086 00000282 f3bd5c5c c0902306 f3bd5c7c c044d2be c0c7c300
[23844.651074]  b538a613 000014fd c0c7c300 00000000 000014fd f3bf0c90 c0440162 00000000
[23844.651082]  c0b9e0d8 f3b8ab60 00000000 00000303 f3bd5c98 f3bd5c98 f3b8ab60 00000006
[23844.651092] Call Trace:
[23844.651106]  [<c0902306>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[23844.651113]  [<c044d2be>] ? __wake_up+0x3b/0x42
[23844.651121]  [<c0440162>] ? call_usermodehelper_fns+0x148/0x152
[23844.651127]  [<c0440410>] ? __request_module+0x15e/0x1a1
[23844.651133]  [<c043fde5>] ? call_usermodehelper_freeinfo+0x19/0x19
[23844.651138]  [<c0901ada>] schedule+0x51/0x53
[23844.651142]  [<c0901c2d>] schedule_preempt_disabled+0x8/0xa
[23844.651150]  [<c0900e26>] __mutex_lock_common+0xd6/0x123
[23844.651156]  [<c0900f79>] __mutex_lock_slowpath+0x20/0x22
[23844.651162]  [<c0900f1f>] ? mutex_lock+0x18/0x25
[23844.651167]  [<c0900f1f>] mutex_lock+0x18/0x25
[23844.651176]  [<c05e1580>] cifs_reconnect_tcon+0x170/0x252
[23844.651182]  [<c0450644>] ? resched_task+0x5e/0x61
[23844.651188]  [<c05e167f>] smb_init+0x1d/0x6d
[23844.651193]  [<c05e4eaf>] CIFSSMBQPathInfo+0x4e/0x1e4
[23844.651201]  [<c05fdfbc>] cifs_query_path_info+0x38/0x73
[23844.651207]  [<c05f455a>] cifs_get_inode_info+0x122/0x3ac
[23844.651215]  [<c04e1e87>] ? walk_component+0x14a/0x17a
[23844.651220]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23844.651225]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23844.651230]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23844.651235]  [<c04e215c>] ? getname_flags+0x1/0xeb
[23844.651240]  [<c09022ba>] ? _raw_spin_lock+0x8/0xa
[23844.651246]  [<c05f5bd4>] cifs_revalidate_dentry_attr+0x120/0x168
[23844.651252]  [<c05f5cbd>] cifs_getattr+0x5e/0xe3
[23844.651258]  [<c04dda16>] ? cp_new_stat64+0xef/0x101
[23844.651263]  [<c04dddde>] vfs_getattr+0x37/0x4e
[23844.651269]  [<c05f5c5f>] ? cifs_revalidate_dentry+0x20/0x20
[23844.651274]  [<c04dde4e>] vfs_fstatat+0x59/0x8a
[23844.651280]  [<c04ddeb3>] vfs_stat+0x19/0x1b
[23844.651285]  [<c04de0b8>] sys_stat64+0x11/0x22
[23844.651292]  [<c0907951>] sysenter_do_call+0x12/0x2c
[23964.456484] INFO: task bash:2711 blocked for more than 120 seconds.
[23964.456492] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23964.456496] bash            D f3bd5c5c     0  2711   2689 0x00000000
[23964.456503]  f3bd5cd0 00000086 00000282 f3bd5c5c c0902306 f3bd5c7c c044d2be c0c7c300
[23964.456514]  b538a613 000014fd c0c7c300 00000000 000014fd f3bf0c90 c0440162 00000000
[23964.456523]  c0b9e0d8 f3b8ab60 00000000 00000303 f3bd5c98 f3bd5c98 f3b8ab60 00000006
[23964.456532] Call Trace:
[23964.456547]  [<c0902306>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[23964.456559]  [<c044d2be>] ? __wake_up+0x3b/0x42
[23964.456568]  [<c0440162>] ? call_usermodehelper_fns+0x148/0x152
[23964.456573]  [<c0440410>] ? __request_module+0x15e/0x1a1
[23964.456579]  [<c043fde5>] ? call_usermodehelper_freeinfo+0x19/0x19
[23964.456584]  [<c0901ada>] schedule+0x51/0x53
[23964.456589]  [<c0901c2d>] schedule_preempt_disabled+0x8/0xa
[23964.456597]  [<c0900e26>] __mutex_lock_common+0xd6/0x123
[23964.456603]  [<c0900f79>] __mutex_lock_slowpath+0x20/0x22
[23964.456608]  [<c0900f1f>] ? mutex_lock+0x18/0x25
[23964.456614]  [<c0900f1f>] mutex_lock+0x18/0x25
[23964.456622]  [<c05e1580>] cifs_reconnect_tcon+0x170/0x252
[23964.456629]  [<c0450644>] ? resched_task+0x5e/0x61
[23964.456635]  [<c05e167f>] smb_init+0x1d/0x6d
[23964.456640]  [<c05e4eaf>] CIFSSMBQPathInfo+0x4e/0x1e4
[23964.456648]  [<c05fdfbc>] cifs_query_path_info+0x38/0x73
[23964.456654]  [<c05f455a>] cifs_get_inode_info+0x122/0x3ac
[23964.456662]  [<c04e1e87>] ? walk_component+0x14a/0x17a
[23964.456667]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23964.456672]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23964.456678]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
[23964.456683]  [<c04e215c>] ? getname_flags+0x1/0xeb
[23964.456687]  [<c09022ba>] ? _raw_spin_lock+0x8/0xa
[23964.456693]  [<c05f5bd4>] cifs_revalidate_dentry_attr+0x120/0x168
[23964.456699]  [<c05f5cbd>] cifs_getattr+0x5e/0xe3
[23964.456705]  [<c04dda16>] ? cp_new_stat64+0xef/0x101
[23964.456711]  [<c04dddde>] vfs_getattr+0x37/0x4e
[23964.456716]  [<c05f5c5f>] ? cifs_revalidate_dentry+0x20/0x20
[23964.456721]  [<c04dde4e>] vfs_fstatat+0x59/0x8a
[23964.456727]  [<c04ddeb3>] vfs_stat+0x19/0x1b
[23964.456732]  [<c04de0b8>] sys_stat64+0x11/0x22
[23964.456739]  [<c0907951>] sysenter_do_call+0x12/0x2c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
