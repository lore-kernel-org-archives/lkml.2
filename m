Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2HFV4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:56:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54812 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2HFVz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120806204245.GI25559@redhat.com>
References: <1339478463-31172-1-git-send-email-amwang@redhat.com>
	<5004D8BF.6050205@jp.fujitsu.com>
	<500D20A1.1030800@redhat.com>
	<500D340F.5080801@jp.fujitsu.com>
	<1343145331.16290.45.camel@cr0>
	<500F3B7C.70009@jp.fujitsu.com>
	<20120806204245.GI25559@redhat.com>
Date: Mon, 6 Aug 2012 14:55:55 -0700
X-Google-Sender-Auth: i8uXaJaLRVxXq_of_z7EXdXSqzI
Message-ID: <CAE9FiQW1AiKPVsesmQD5yTk1+4w56pkcDrsRo2yZThuB+2bsOQ@mail.gmail.com>
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, amwang@redhat.com, tiwai@suse.de,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        xiyou.wangcong@gmail.com, akpm@linux-foundation.org, dyoung@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 1:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:

>
> Did something happen on this patch. We definitely want to gain back the
> capability to be able to reserve 512MB of kdump memory.

Maybe Ingo and peter could push that to Linus.

Assume we have Acked-by from you, me and others.

Thanks

Yinghai
