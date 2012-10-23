Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2JWIRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:17:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45947 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2JWIR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:17:27 -0400
X-AuditID: cbfee612-b7f3d6d000004f13-80-50865290dbe9
Date: Tue, 23 Oct 2012 08:17:20 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: 3.7-rc2 regression : file copied to CIFS-mounted directory
 corrupted
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: =?utf-8?Q?=ED=97=88=EC=A2=85=EB=A7=8C?= <jongman.heo@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20121023081502596@jongman.heo
Msgkey: 20121023081502596@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121023081502596@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <33091139.64321350980240110.JavaMail.weblogic@epml04>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t8zPd0JQW0BBiv2mFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Meys+shacu8JY8eLucvYGxgnnGbsYOTmEBNQkbn4+BGZLCJhI
	XJy/hg3CFpO4cG89kM0FVLOMUWLF3SOsXYwcYEWrT3pDxOczSlzYd54JpIFFQFVi56PnLCA2
	m4CORMf//awgtrBAqET75kZ2EFtEQFti+dodTCDNzAJvGCW+H3jCBHGFosS1pYvBNvMKCEqc
	nPmEBeIKFYne21dYIeKqEn83z2SHiItLXJh7CcrmlZjR/hSqXk5i2tc1zBC2tMT5WRsYYb5Z
	/P0xVJxf4thtkCM4wHqf3A+GGbN78xeo5wUkpp45CNWqKbF79UqoOJ/EmoVvWWDG7Dq1nBmm
	9/6WuWCvMAO9MqX7ITvIeGag3vW79NF9xSvgKPHk826WCYzKs5CkZiHpnoXQjaxkASPLKkbR
	1ILkguKk9FQLveLE3OLSvHS95PzcTYyQxCC0g3FZg8UhRgEORiUeXgv+tgAh1sSy4srcQ4wS
	HMxKIrym9kAh3pTEyqrUovz4otKc1OJDjD7A+JvILCWanA9MWnkl8YbGBsaGhpaGZqaWpgY4
	hJXEeSs8UgKEBNITS1KzU1MLUotgxjFxcEo1MG48+/XD56tC1q4fYn5feerKEbq6evKTZrEf
	W86KCzutVbCaN2Mni/zJHT9zOFZsOr+Q9/5Uk/3d7w7bByZXPju5mqE4jcPv1v1NS0X/1nS6
	Tp3Y/cJwHUOJ/JqAHVvtO47Lin+VO2Abf1B9+pIqSX/G0xLKu798m2Qrc/+unfnpnf1Nzm+f
	iWoosRRnJBpqMRcVJwIAzSH+5TkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t/tmboTgtoCDP7/1re4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GfdWfGQtOHeFseLF3eXsDYwTzjN2MXJyCAmoSdz8fAjI5uCQEDCRWH3SGyQsISAmceHeerYu
	Ri6gkvmMEhf2nWcCSbAIqErsfPScBcRmE9CR6Pi/nxXEFhYIlWjf3MgOYosIaEssX7uDCaSZ
	WeANo8T3A0+YIJYpSlxbupgNxOYVEJQ4OfMJC8Q2FYne21dYIeKqEn83z2SHiItLXJh7Ccrm
	lZjR/hSqXk5i2tc1zBC2tMT5WRsYYa5e/P0xVJxf4thtkCM4wHqf3A+GGbN78xc2CFtAYuqZ
	g1CtmhK7V6+EivNJrFn4lgVmzK5Ty5lheu9vmQv2CjPQK1O6H7KDjGcG6l2/Sx/dV7wCjhJP
	Pu9mmcAoNwtJahaS7lkI3chKFjCyrGIUTS1ILihOSk+10CtOzC0uzUvXS87P3cQITlHPhHYw
	LmuwOMQowMGoxMNrwd8WIMSaWFZcmXuIUYKDWUmE19QeKMSbklhZlVqUH19UmpNafIjRBxh/
	E5mlRJPzgekzryTe0NjA2NDQ0tzA1NDIAoewkjhvhUdKgJBAemJJanZqakFqEcw4Jg5OqQZG
	ucUPUguOmb7LX+n3M3vP3MtdscYfJbdZPz7wMPfkp5sakqK+me+V7mbtLnaRWzv92bQ/RlnC
	bTJ5+yce33x53vG0R9HZ0paeTXa3vt++XMUQ8m/NtfCS0iqGdR2PNtQxPQ3ok6nnnMi/01ZI
	vnjuun1PlLQYmK5Obch+e/jpLflFPC/6PW4nKrEUZyQaajEXFScCAAUxWPt+AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9N8Hj3M002062


Hi,

------- Original Message -------
Sender : Eric Dumazet<eric.dumazet@gmail.com>
Date : 2012-10-23 15:08 (GMT+09:00)
Title : Re: 3.7-rc2 regression : file copied to CIFS-mounted directory corrupted

On Tue, 2012-10-23 at 05:38 +0000, Jongman Heo wrote:
> Hmm,
> 
> I've just met the issue, with the commit 5640f768 reverted.
> It seems that the issue does not always happen. So, my bisection may not be correct.
> 
> At this moment, I don't have enough time to do bisection again..
> 
> Regards.

What happens, if instead of reverting you try the following ?

If this solves the problem, then we shall find the driver that assumes
frags are order-0 pages only.

diff --git a/net/core/sock.c b/net/core/sock.c
index 8a146cf..a743e7c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1726,7 +1726,7 @@ struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
EXPORT_SYMBOL(sock_alloc_send_skb);

/* On 32bit arches, an skb frag is limited to 2^15 */
-#define SKB_FRAG_PAGE_ORDER get_order(32768)
+#define SKB_FRAG_PAGE_ORDER 0

bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
{

------------------------------------------------------------------------------------

With above patch, the issue is not reproduced so far.

 - Current mainline                                    :  issue reproduced on 1st run
 - Reverting commit 5640f768 (tested again)  : not reproduced until 300 runs
 - Applying above patch                             : not reproduced until 300 runs

To be sure, maybe more testing is needed...

FYI, vmxnet3 driver is used for ethernet.

When the issue happens, following error messages were emitted.

[   84.445735] CIFS VFS: default security mechanism requested.  The default security mechanism will be upgraded from ntlm to ntlmv2 in kernel release 3.3
[   87.135291] net eth0: eth0: tq[0] error 0x80000000
[   87.135298] net eth0: eth0: tq[1] error 0x80000000
[   87.135402] eth0: resetting
[   87.146071] eth0: intr type 3, mode 0, 5 vectors allocated
[   87.146695] eth0: NIC Link is Up 10000 Mbps
[   88.925044] CIFS VFS: Error -104 sending data on socket to server
[   98.934656] CIFS VFS: No writable handles for inode
[   98.938317] CIFS VFS: No writable handles for inode
[   98.940895] CIFS VFS: No writable handles for inode
[   98.943712] CIFS VFS: No writable handles for inode
[   98.946050] CIFS VFS: No writable handles for inode
[   98.948569] CIFS VFS: No writable handles for inode
[   98.951320] CIFS VFS: No writable handles for inode
[   98.954675] CIFS VFS: No writable handles for inode
[   98.957188] CIFS VFS: No writable handles for inode
[   98.960622] CIFS VFS: No writable handles for inode
[   98.963083] CIFS VFS: No writable handles for inode
[   98.965851] CIFS VFS: No writable handles for inode
[   98.970822] CIFS VFS: No writable handles for inode
[   98.973132] CIFS VFS: No writable handles for inode
[   98.976405] CIFS VFS: No writable handles for inode
[   98.978737] CIFS VFS: No writable handles for inode
[   98.981645] CIFS VFS: No writable handles for inode
[   98.983794] CIFS VFS: No writable handles for inode
[   98.987325] CIFS VFS: No writable handles for inode
[   98.989483] CIFS VFS: No writable handles for inode
[   98.991317] CIFS VFS: No writable handles for inode
[   98.993488] CIFS VFS: No writable handles for inode
[   98.995697] CIFS VFS: No writable handles for inode
[   98.997633] CIFS VFS: No writable handles for inode
[   98.999935] CIFS VFS: No writable handles for inode
[   99.002929] CIFS VFS: No writable handles for inode
[   99.004821] CIFS VFS: No writable handles for inode
[   99.006988] CIFS VFS: No writable handles for inode
[   99.009084] CIFS VFS: No writable handles for inode
[   99.011119] CIFS VFS: No writable handles for inode
[   99.013276] CIFS VFS: No writable handles for inode
[   99.018433] CIFS VFS: No writable handles for inode
[   99.020087] CIFS VFS: No writable handles for inode
[   99.022303] CIFS VFS: No writable handles for inode
[   99.024561] CIFS VFS: No writable handles for inode
[   99.027029] CIFS VFS: No writable handles for inode
[   99.029989] CIFS VFS: No writable handles for inode
[   99.031945] CIFS VFS: No writable handles for inode
[   99.033966] CIFS VFS: No writable handles for inode
[   99.036478] CIFS VFS: No writable handles for inode
[   99.038424] CIFS VFS: No writable handles for inode
[   99.040542] CIFS VFS: No writable handles for inode
[   99.043051] CIFS VFS: No writable handles for inode
[   99.045687] CIFS VFS: No writable handles for inode
[   99.047890] CIFS VFS: No writable handles for inode
[   99.049974] CIFS VFS: No writable handles for inode
[   99.051911] CIFS VFS: No writable handles for inode
[   99.053984] CIFS VFS: No writable handles for inode
[   99.056304] CIFS VFS: No writable handles for inode
[   99.058446] CIFS VFS: No writable handles for inode
[   99.060956] CIFS VFS: No writable handles for inode
[   99.063243] CIFS VFS: No writable handles for inode
[   99.065744] CIFS VFS: No writable handles for inode
[   99.068592] CIFS VFS: No writable handles for inode
[   99.072413] CIFS VFS: No writable handles for inode
[   99.074762] CIFS VFS: No writable handles for inode
[   99.077070] CIFS VFS: No writable handles for inode
[   99.079275] CIFS VFS: No writable handles for inode
[   99.081153] CIFS VFS: No writable handles for inode
[   99.084438] CIFS VFS: No writable handles for inode
[   99.085381] CIFS VFS: No writable handles for inode
[   99.087665] CIFS VFS: No writable handles for inode
[   99.089626] CIFS VFS: No writable handles for inode
[   99.093592] CIFS VFS: No writable handles for inode
[   99.093917] CIFS VFS: No writable handles for inode
[   99.098944] CIFS VFS: No writable handles for inode
[   99.099862] CIFS VFS: No writable handles for inode
[   99.101750] CIFS VFS: No writable handles for inode
[   99.103742] CIFS VFS: No writable handles for inode
[   99.105721] CIFS VFS: No writable handles for inode
[   99.108514] CIFS VFS: No writable handles for inode
[   99.110649] CIFS VFS: No writable handles for inode
[   99.112777] CIFS VFS: No writable handles for inode
[   99.114931] CIFS VFS: No writable handles for inode
[   99.116961] CIFS VFS: No writable handles for inode
[   99.118876] CIFS VFS: No writable handles for inode
[   99.121018] CIFS VFS: No writable handles for inode
[   99.123855] CIFS VFS: No writable handles for inode
[   99.128161] CIFS VFS: No writable handles for inode
[   99.131628] CIFS VFS: No writable handles for inode
[   99.133981] CIFS VFS: No writable handles for inode
[   99.136556] CIFS VFS: No writable handles for inode
[   99.144838] CIFS VFS: No writable handles for inode
[   99.145400] CIFS VFS: No writable handles for inode
[   99.147937] CIFS VFS: No writable handles for inode
[   99.150207] CIFS VFS: No writable handles for inode
[   99.152736] CIFS VFS: No writable handles for inode
[   99.155053] CIFS VFS: No writable handles for inode
[   99.159129] CIFS VFS: No writable handles for inode
[   99.161704] CIFS VFS: No writable handles for inode
[   99.164052] CIFS VFS: No writable handles for inode
[   99.165932] CIFS VFS: No writable handles for inode
[   99.167853] CIFS VFS: No writable handles for inode
[   99.170069] CIFS VFS: No writable handles for inode
[   99.173877] CIFS VFS: No writable handles for inode
[   99.176124] CIFS VFS: No writable handles for inode
[   99.178481] CIFS VFS: No writable handles for inode
[   99.180650] CIFS VFS: No writable handles for inode
[   99.182594] CIFS VFS: No writable handles for inode
[   99.184490] CIFS VFS: No writable handles for inode
[   99.186808] CIFS VFS: No writable handles for inode
[   99.189290] CIFS VFS: No writable handles for inode
[   99.191268] CIFS VFS: No writable handles for inode
[   99.193450] CIFS VFS: No writable handles for inode
[   99.195688] CIFS VFS: No writable handles for inode
[   99.197691] CIFS VFS: No writable handles for inode
[   99.199917] CIFS VFS: No writable handles for inode
[   99.202435] CIFS VFS: No writable handles for inode
[   99.204365] CIFS VFS: No writable handles for inode
[   99.207785] CIFS VFS: No writable handles for inode
[   99.208852] CIFS VFS: No writable handles for inode
[   99.210881] CIFS VFS: No writable handles for inode
[   99.212819] CIFS VFS: No writable handles for inode
[   99.214687] CIFS VFS: No writable handles for inode
[   99.217646] CIFS VFS: No writable handles for inode
[   99.219113] CIFS VFS: No writable handles for inode
[   99.221024] CIFS VFS: No writable handles for inode
[   99.223119] CIFS VFS: No writable handles for inode
[   99.225714] CIFS VFS: No writable handles for inode
[   99.227819] CIFS VFS: No writable handles for inode
[   99.230155] CIFS VFS: No writable handles for inode
[   99.232507] CIFS VFS: No writable handles for inode
[   99.234721] CIFS VFS: No writable handles for inode
[   99.237112] CIFS VFS: No writable handles for inode
[   99.239099] CIFS VFS: No writable handles for inode
[   99.241165] CIFS VFS: No writable handles for inode
[   99.243192] CIFS VFS: No writable handles for inode
[   99.245056] CIFS VFS: No writable handles for inode
[   99.247091] CIFS VFS: No writable handles for inode
[   99.249537] CIFS VFS: No writable handles for inode
[   99.251581] CIFS VFS: No writable handles for inode
[   99.254136] CIFS VFS: No writable handles for inode
[   99.255693] CIFS VFS: No writable handles for inode
[   99.257751] CIFS VFS: No writable handles for inode
[   99.260073] CIFS VFS: No writable handles for inode
[   99.262034] CIFS VFS: No writable handles for inode
[   99.263945] CIFS VFS: No writable handles for inode
[   99.268429] CIFS VFS: No writable handles for inode
[   99.269245] CIFS VFS: No writable handles for inode
[   99.271384] CIFS VFS: No writable handles for inode
[   99.284337] CIFS VFS: No writable handles for inode
[   99.286461] CIFS VFS: No writable handles for inode
[   99.288751] CIFS VFS: No writable handles for inode
[   99.291391] CIFS VFS: No writable handles for inode
[   99.293489] CIFS VFS: No writable handles for inode
[   99.295453] CIFS VFS: No writable handles for inode
[   99.297539] CIFS VFS: No writable handles for inode
[   99.299699] CIFS VFS: No writable handles for inode
[   99.301625] CIFS VFS: No writable handles for inode
[   99.303612] CIFS VFS: No writable handles for inode
[   99.307376] CIFS VFS: No writable handles for inode
[   99.307746] CIFS VFS: No writable handles for inode
[   99.310013] CIFS VFS: No writable handles for inode
[   99.314325] CIFS VFS: No writable handles for inode
[   99.314975] CIFS VFS: No writable handles for inode
[   99.317209] CIFS VFS: No writable handles for inode
[   99.319170] CIFS VFS: No writable handles for inode
[   99.321063] CIFS VFS: No writable handles for inode
[   99.324000] CIFS VFS: No writable handles for inode
[   99.325868] CIFS VFS: No writable handles for inode
[   99.328080] CIFS VFS: No writable handles for inode
[   99.330139] CIFS VFS: No writable handles for inode
[   99.332033] CIFS VFS: No writable handles for inode
[   99.333893] CIFS VFS: No writable handles for inode
[   99.336164] CIFS VFS: No writable handles for inode
[   99.338178] CIFS VFS: No writable handles for inode
[   99.340240] CIFS VFS: No writable handles for inode
[   99.344359] CIFS VFS: No writable handles for inode
[   99.345060] CIFS VFS: No writable handles for inode
[   99.347397] CIFS VFS: No writable handles for inode
[   99.349643] CIFS VFS: No writable handles for inode
[   99.351537] CIFS VFS: No writable handles for inode
[   99.353579] CIFS VFS: No writable handles for inode
[   99.355830] CIFS VFS: No writable handles for inode
[   99.359613] CIFS VFS: No writable handles for inode
[   99.361690] CIFS VFS: No writable handles for inode
[   99.363793] CIFS VFS: No writable handles for inode
[   99.365703] CIFS VFS: No writable handles for inode
[   99.367615] CIFS VFS: No writable handles for inode
[   99.369506] CIFS VFS: No writable handles for inode
[   99.371413] CIFS VFS: No writable handles for inode
[   99.373504] CIFS VFS: No writable handles for inode
[   99.377574] CIFS VFS: No writable handles for inode
[   99.380010] CIFS VFS: No writable handles for inode
[   99.382033] CIFS VFS: No writable handles for inode
[   99.384279] CIFS VFS: No writable handles for inode
[   99.386217] CIFS VFS: No writable handles for inode
[   99.388558] CIFS VFS: No writable handles for inode
[   99.390884] CIFS VFS: No writable handles for inode
[   99.393282] CIFS VFS: No writable handles for inode
[   99.395154] CIFS VFS: No writable handles for inode
[   99.397046] CIFS VFS: No writable handles for inode
[   99.398986] CIFS VFS: No writable handles for inode
[   99.400920] CIFS VFS: No writable handles for inode
[   99.402976] CIFS VFS: No writable handles for inode
[   99.405042] CIFS VFS: No writable handles for inode
[   99.407172] CIFS VFS: No writable handles for inode
[   99.409224] CIFS VFS: No writable handles for inode
[   99.411218] CIFS VFS: No writable handles for inode
[   99.413171] CIFS VFS: No writable handles for inode
[   99.415035] CIFS VFS: No writable handles for inode
[   99.417124] CIFS VFS: No writable handles for inode
[   99.419719] CIFS VFS: No writable handles for inode
[  158.477345] net eth0: eth0: tq[0] error 0x80000000
[  158.477353] net eth0: eth0: tq[1] error 0x80000000
[  158.477448] eth0: resetting
[  158.486170] eth0: intr type 3, mode 0, 5 vectors allocated
[  158.486718] eth0: NIC Link is Up 10000 Mbps
[  160.223384] net eth0: eth0: tq[0] error 0x80000000
[  160.223392] net eth0: eth0: tq[1] error 0x80000000
[  160.223507] eth0: resetting
[  160.236060] eth0: intr type 3, mode 0, 5 vectors allocated
[  160.236654] eth0: NIC Link is Up 10000 Mbps
[  161.965368] net eth0: eth0: tq[0] error 0x80000000
[  161.965374] net eth0: eth0: tq[1] error 0x80000000
[  161.965409] eth0: resetting
[  161.974675] eth0: intr type 3, mode 0, 5 vectors allocated
[  161.975219] eth0: NIC Link is Up 10000 Mbps
[  162.441348] net eth0: eth0: tq[0] error 0x80000000
[  162.441356] net eth0: eth0: tq[1] error 0x80000000
[  162.441467] eth0: resetting
[  162.451447] eth0: intr type 3, mode 0, 5 vectors allocated
[  162.451791] eth0: NIC Link is Up 10000 Mbps
[  162.733057] net eth0: eth0: tq[0] error 0x80000000
[  162.733064] net eth0: eth0: tq[1] error 0x80000000
[  162.733103] eth0: resetting
[  162.743815] eth0: intr type 3, mode 0, 5 vectors allocated
[  162.744189] eth0: NIC Link is Up 10000 Mbps
[  163.028137] net eth0: eth0: tq[0] error 0x80000000
[  163.028143] net eth0: eth0: tq[1] error 0x80000000
[  163.028184] eth0: resetting
[  163.040926] eth0: intr type 3, mode 0, 5 vectors allocated
[  163.041285] eth0: NIC Link is Up 10000 Mbps
[  163.620144] net eth0: eth0: tq[0] error 0x80000000
[  163.620150] net eth0: eth0: tq[1] error 0x80000000
[  163.620246] eth0: resetting
[  163.632021] eth0: intr type 3, mode 0, 5 vectors allocated
[  163.632586] eth0: NIC Link is Up 10000 Mbps
[  164.016532] net eth0: eth0: tq[0] error 0x80000000
[  164.016540] net eth0: eth0: tq[1] error 0x80000000
[  164.016558] eth0: resetting
[  164.026814] eth0: intr type 3, mode 0, 5 vectors allocated
[  164.027315] eth0: NIC Link is Up 10000 Mbps
[  165.855878] net eth0: eth0: tq[0] error 0x80000000
[  165.855886] net eth0: eth0: tq[1] error 0x80000000
[  165.855935] eth0: resetting
[  165.865117] eth0: intr type 3, mode 0, 5 vectors allocated
[  165.865492] eth0: NIC Link is Up 10000 Mbps
[  166.314014] net eth0: eth0: tq[0] error 0x80000000
[  166.314021] net eth0: eth0: tq[1] error 0x80000000
[  166.314107] eth0: resetting
[  166.323707] eth0: intr type 3, mode 0, 5 vectors allocated
[  166.324065] eth0: NIC Link is Up 10000 Mbps
[  166.615083] net eth0: eth0: tq[0] error 0x80000000
[  166.615089] net eth0: eth0: tq[1] error 0x80000000
[  166.615153] eth0: resetting
[  166.624537] eth0: intr type 3, mode 0, 5 vectors allocated
[  166.624945] eth0: NIC Link is Up 10000 Mbps
[  166.918213] net eth0: eth0: tq[0] error 0x80000000
[  166.918220] net eth0: eth0: tq[1] error 0x80000000
[  166.918296] eth0: resetting
[  166.927277] eth0: intr type 3, mode 0, 5 vectors allocated
[  166.927540] eth0: NIC Link is Up 10000 Mbps
[  167.187279] net eth0: eth0: tq[0] error 0x80000000
[  167.187286] net eth0: eth0: tq[1] error 0x80000000
[  167.187373] eth0: resetting
[  167.196182] eth0: intr type 3, mode 0, 5 vectors allocated
[  167.196639] eth0: NIC Link is Up 10000 Mbps
[  167.479262] net eth0: eth0: tq[0] error 0x80000000
[  167.479270] net eth0: eth0: tq[1] error 0x80000000
[  167.479369] eth0: resetting
[  167.488185] eth0: intr type 3, mode 0, 5 vectors allocated
[  167.488563] eth0: NIC Link is Up 10000 Mbps
[  167.938086] net eth0: eth0: tq[0] error 0x80000000
[  167.938092] net eth0: eth0: tq[1] error 0x80000000
[  167.938128] eth0: resetting
[  167.950384] eth0: intr type 3, mode 0, 5 vectors allocated
[  167.950777] eth0: NIC Link is Up 10000 Mbps
[  168.209071] net eth0: eth0: tq[0] error 0x80000000
[  168.209078] net eth0: eth0: tq[1] error 0x80000000
[  168.209220] eth0: resetting
[  168.218303] eth0: intr type 3, mode 0, 5 vectors allocated
[  168.218577] eth0: NIC Link is Up 10000 Mbps
[  168.527235] net eth0: eth0: tq[0] error 0x80000000
[  168.527241] net eth0: eth0: tq[1] error 0x80000000
[  168.527263] eth0: resetting
[  168.538101] eth0: intr type 3, mode 0, 5 vectors allocated
[  168.538471] eth0: NIC Link is Up 10000 Mbps
[  168.796622] net eth0: eth0: tq[0] error 0x80000000
[  168.796628] net eth0: eth0: tq[1] error 0x80000000
[  168.796664] eth0: resetting
[  168.807190] eth0: intr type 3, mode 0, 5 vectors allocated
[  168.807463] eth0: NIC Link is Up 10000 Mbps
[  169.178494] net eth0: eth0: tq[0] error 0x80000000
[  169.178503] net eth0: eth0: tq[1] error 0x80000000
[  169.178668] eth0: resetting
[  169.187163] eth0: intr type 3, mode 0, 5 vectors allocated
[  169.187518] eth0: NIC Link is Up 10000 Mbps
[  169.425058] net eth0: eth0: tq[0] error 0x80000000
[  169.425064] net eth0: eth0: tq[1] error 0x80000000
[  169.425097] eth0: resetting
[  169.436125] eth0: intr type 3, mode 0, 5 vectors allocated
[  169.436492] eth0: NIC Link is Up 10000 Mbps
[  169.824717] net eth0: eth0: tq[0] error 0x80000000
[  169.824724] net eth0: eth0: tq[1] error 0x80000000
[  169.824808] eth0: resetting
[  169.837647] eth0: intr type 3, mode 0, 5 vectors allocated
[  169.837918] eth0: NIC Link is Up 10000 Mbps
[  170.249090] net eth0: eth0: tq[0] error 0x80000000
[  170.249097] net eth0: eth0: tq[1] error 0x80000000
[  170.249112] eth0: resetting
[  170.259593] eth0: intr type 3, mode 0, 5 vectors allocated
[  170.259888] eth0: NIC Link is Up 10000 Mbps
[  172.100435] net eth0: eth0: tq[0] error 0x80000000
[  172.100442] net eth0: eth0: tq[1] error 0x80000000
[  172.100522] eth0: resetting
[  172.113332] eth0: intr type 3, mode 0, 5 vectors allocated
[  172.113614] eth0: NIC Link is Up 10000 Mbps
[  172.396308] net eth0: eth0: tq[0] error 0x80000000
[  172.396314] net eth0: eth0: tq[1] error 0x80000000
[  172.396412] eth0: resetting
[  172.406927] eth0: intr type 3, mode 0, 5 vectors allocated
[  172.407198] eth0: NIC Link is Up 10000 Mbps
[  172.891922] net eth0: eth0: tq[0] error 0x80000000
[  172.891930] net eth0: eth0: tq[1] error 0x80000000
[  172.891951] eth0: resetting
[  172.902945] eth0: intr type 3, mode 0, 5 vectors allocated
[  172.903226] eth0: NIC Link is Up 10000 Mbps
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
