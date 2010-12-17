Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0LQD3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:29:04 -0500
Received: from [120.35.11.139] ([120.35.11.139]:55943 "EHLO fzex.ruijie.com.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752573Ab0LQD3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:29:02 -0500
From: =?utf-8?B?5p6X5ZiJKOeglOS4gyDnpo/lt54p?= <linjia@ruijie.com.cn>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: a question about netlink?
Thread-Topic: a question about netlink?
Thread-Index: AcudmR8JqQ1E7VARSH++sKvbtz6XdQAAVoZQ
Date: Fri, 17 Dec 2010 03:29:13 +0000
Message-ID: <54A83BDB1B497D429FE6D4D3A6E5C5C919150531@fzex.ruijie.com.cn>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BA6G C2nk DPPI DbzE DgIy EIZc EnDw FVCi Fp84 GnaI Gs/6
 HUMS HU8U Hyrm Kx2A
 MyMm;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{8BCC22F5-7EFE-4856-AFD2-A6771B34B0C0};bABpAG4AagBpAGEAQAByAHUAaQBqAGkAZQAuAGMAbwBtAC4AYwBuAA==;Fri,
 17 Dec 2010 03:29:13
 GMT;YQAgAHEAdQBlAHMAdABpAG8AbgAgAGEAYgBvAHUAdAAgAG4AZQB0AGwAaQBuAGsAPwA=
x-cr-puzzleid: {8BCC22F5-7EFE-4856-AFD2-A6771B34B0C0}
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oBH3THlc023163

in af_netlink.c

do_one_broadcast
{
Â Â Â Â Â Â Â Â  if (nlk->pid == p->pid || p->group - 1 >= nlk->ngroups ||
Â Â Â Â Â Â Â Â  Â Â Â  !test_bit(p->group - 1, nlk->groups))
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  goto out;
}

why here write:" p->group - 1 >= nlk->ngroups" but not " p->group > nlk->ngroups " , or " (p->group & nlk->ngroups) != 0 "

I think the message is only sento nlk whoes groups 'p->group' bit is set.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
