Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2KNBps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:45:48 -0500
Received: from spam1.webland.se ([91.207.112.90]:52858 "EHLO spam1.webland.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab2KNBpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:45:47 -0500
From: Arvid Brodin <Arvid.Brodin@xdin.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Cyrill Gorcunov" <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] fs/proc: Add process text segment md5-summing
Thread-Topic: [PATCH] fs/proc: Add process text segment md5-summing
Thread-Index: AQHNwUTUqn3lr7PkbEaV3fGGkgsdL5fogDmA
Date: Wed, 14 Nov 2012 01:45:46 +0000
Message-ID: <50A2F7C9.2030006@xdin.com>
References: <50A16BD0.7030600@xdin.com>
 <20121112150325.2516a0bf.akpm@linux-foundation.org>
 <871ufyjli4.fsf@xmission.com>
In-Reply-To: <871ufyjli4.fsf@xmission.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120410
 Thunderbird/8.0
Content-Type: text/plain; charset="utf-8"
Content-ID: <67E74A8B4ABC2D4F817CAEA09BC93F4D@redbull.xdin.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAE1jqxs019178

On 2012-11-13 03:16, Eric W. Biederman wrote:
> To add another nail in the coffin.
> 
> You can do this with ptrace or with /proc/<pid>/mem without a kernel
> patch.
> 
> To make this safe would need a ptrace_may_acces(PTRACE_MODE_READ)
> permission check.  At which point not doing this with ptrace just adds
> up to extra kernel maintenance for no real point.

If my client still wants to run text segment checks, even after the
criticism of the idea behind the patch, the above should prove very
handy. Thanks!


-- 
Arvid Brodin | Consultant (Linux)
XDIN AB | KnarrarnÃ¤sgatan 7 | SE-164 40 Kista | Sweden | xdin.comÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
