Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2EFUvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 16:51:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36205 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab2EFUvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 16:51:47 -0400
References: <4FA6BBD9.3040308@zytor.com> <20120506184641.GW6871@ZenIV.linux.org.uk> <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com> <20120506.163243.1653904376439925642.davem@davemloft.net>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120506.163243.1653904376439925642.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 06 May 2012 13:51:30 -0700
To: David Miller <davem@davemloft.net>
CC: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org
Message-ID: <af01067e-5a22-44a8-acb1-368e45dbb06c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No.  The input layer exports pointers in structures on the read/write paths, and bitmasks encoded in ASCII strings which depend on sizeof(long).  The stupid... it burns...

David Miller <davem@davemloft.net> wrote:

>From: "H. Peter Anvin" <hpa@zytor.com>
>Date: Sun, 06 May 2012 11:48:15 -0700
>
>> I would argue Sparc is not correct here but I am not a Sparc expert.
>
>I can easily make sparc take on the x86 behavior if things like the
>input layer really need it.
>
>However, isn't the input layer case a case where compat==native
>on anything other than x86 because it's a u64 alignment issue?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
