Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0KNTda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 14:33:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab0KNTd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 14:33:29 -0500
MIME-Version: 1.0
In-Reply-To: <20101114133543.E00A.A69D9226@jp.fujitsu.com>
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Nov 2010 11:32:37 -0800
Message-ID: <AANLkTikSq-qC28uurd17RGup92Kao7enCiGJkDnJG+94@mail.gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Bodo Eggert <7eggert@web.de>,
        Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/13 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>
> Please apply this. this patch revert commits of oom changes since v2.6.35.

I'm not getting involved in this whole flame-war. You need to convince
Andrew, who has been the person everything went through.

                    Linus
