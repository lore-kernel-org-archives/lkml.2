Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2EFXsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 19:48:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36971 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab2EFXsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 19:48:24 -0400
References: <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com> <20120506.163243.1653904376439925642.davem@davemloft.net> <af01067e-5a22-44a8-acb1-368e45dbb06c@email.android.com> <20120506.194037.1148847080889462521.davem@davemloft.net>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120506.194037.1148847080889462521.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 06 May 2012 16:48:00 -0700
To: David Miller <davem@davemloft.net>
CC: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org
Message-ID: <8c91e0ff-dc31-4f94-8008-33d8c3d3c8ef@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not just make it illegal to make the system calls you don't care about then, to prevent any security issue?

David Miller <davem@davemloft.net> wrote:

>From: "H. Peter Anvin" <hpa@zytor.com>
>Date: Sun, 06 May 2012 13:51:30 -0700
>
>> No.  The input layer exports pointers in structures on the
>> read/write paths, and bitmasks encoded in ASCII strings which depend
>> on sizeof(long).  The stupid... it burns...
>
>So there has to be a hack in every userland application wherein we
>teach it no only about this issue, but add special code to teach it
>how to make 64-bit system call traps.
>
>FOR EVERY CPU TYPE?
>
>I'd rather wait for a newer less broken input API to be added, rather
>than go through the pain of having to support 64-bit system calls in
>32-bit apps.
>
>Nobody on sparc has noticed this yet, and I doubt anyone is going to
>care meanwhile.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
