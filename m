Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2JQE7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:59:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64397 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2JQE7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:59:00 -0400
X-AuditID: cbfee612-b7f776d000001e97-3a-507e3b13ea07
Date: Wed, 17 Oct 2012 04:58:58 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] PM / devfreq: fix sscanf handling for writable sysfs
 entries
To: Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121017045830567@myungjoo.ham
Msgkey: 20121017045830567@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121017045830567@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <686519.131861350449936406.JavaMail.weblogic@epml24>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zPV1h67oAgzMnuS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG0cfdLAUr2CuunzjC0sDYw97FyMkhJKAusWjJSTYQW0LAROLs
	nl1QtpjEhXvrgWwuoJpljBI7fu1j7GLkACvqXa4PEZ/PKPF77RFmkAYWAVWJ0w+6mEBq2AT0
	JGZ+TgYJCwuESux9fQNsl4hApETzjZ3MIL3MAqcYJR483cQGcYSSxJp9r1hAbF4BQYmTM5+w
	QByhKvH+1AyouJrE9Od3oOISErOmX2CFsHklZrQ/hYrLSUz7uoYZwpaWOD9rAyPMM4u/P4aK
	80scu72DCeIXXokn94Nhxuze/AXqdwGJqWcOQrVqScy7vQ8qziexZuFbFpgxu04tZ4bpvb9l
	LhOIzSygKDGl+yE7hK0l8eUHRC/CWxxAtoPEhRaLCYzKs5BkZiHpnoWkG1nNAkaWVYyiqQXJ
	BcVJ6akWesWJucWleel6yfm5mxghSUFoB+OyBotDjAIcjEo8vBMn1QYIsSaWFVfmHmKU4GBW
	EuE1bwQK8aYkVlalFuXHF5XmpBYfYvQBxt9EZinR5HxgwsoriTc0NjA2NLQ0NDO1NDXAIawk
	zlvhkRIgJJCeWJKanZpakFoEM46Jg1OqgfHQp2fbajjcshy3PDuWvXrbnYnSk/ks1fsOBeeb
	TUzN/RV+V09Nb2H7OTZPrblmRz85Hv/6SaotT9LvUPTKewd/vXjy63di++tPoXL5HZsWyNoE
	mKcFXX9x4Er2uf3rl+iIT+VoX/iDs+j0cb6NJ932rN7YtWvGV79ZueWcLw6JbWxwrfp584iw
	EktxRqKhFnNRcSIAs71jBDcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t/t6bpC1nUBBqsvKVtc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jKOPu1kKVrBXXD9xhKWBsYe9i5GTQ0hAXWLRkpNsXYwcHBICJhK9y/VBwhICYhIX7q0HCnMB
	lcxnlPi99ggzSIJFQFXi9IMuJpB6NgE9iZmfk0HCwgKhEntf3wAbKSIQKdF8YyczSC+zwClG
	iQdPN7FB7FKSWLPvFQuIzSsgKHFy5hMWiGWqEu9PzYCKq0lMf34HKi4hMWv6BVYIm1diRvtT
	qLicxLSva5ghbGmJ87M2MMIcvfj7Y6g4v8Sx2zuYIP7ilXhyPxhmzO7NX9ggbAGJqWcOQrVq
	Scy7vQ8qziexZuFbFpgxu04tZ4bpvb9lLhOIzSygKDGl+yE7hK0l8eUHRC/CWxxAtoPEhRaL
	CYxys5BkZiHpnoWkG1nNAkaWVYyiqQXJBcVJ6akWesWJucWleel6yfm5mxjB6emZ0A7GZQ0W
	hxgFOBiVeHgnTqoNEGJNLCuuzD3EKMHBrCTCa94IFOJNSaysSi3Kjy8qzUktPsToA4y/icxS
	osn5wNSZVxJvaGxgbGhoaW5gamhkgUNYSZy3wiMlQEggPbEkNTs1tSC1CGYcEwenVAOjZ/Ee
	u5W3fv643vZZ4VBD26rr01jbz5+aNOXzyjI3tc9Xuf7vMl4sKrtoz7+d5toPMvZMnHx94cLG
	/q1OLl7eQfrX+QUkd59f+c24XSMt9+EiTY707+6MIj86m8UKvrz/IP93TsvlDfvFJ3af3zhr
	+cpl3M3PttQ1NKhl2CQ8MNPsi2CplNXVU2Ipzkg01GIuKk4EADlTy018AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9H4x7s6002012

> sscanf returns 0 when an invalid parameter like:
> echo -n "a">min_freq
> is attempted. Returning back the return result(0) will
> cause the command not to return back to command
> prompt.
> 
> Instead, just return -EINVAL when sscanf does not
> return 1.
> 
> This is done for min_freq, max_freq and polling_interval
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
