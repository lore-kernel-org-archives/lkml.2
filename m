Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2BUD6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 22:58:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40104 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab2BUD6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 22:58:43 -0500
Message-ID: <4F431665.3010004@zytor.com>
Date: Mon, 20 Feb 2012 19:58:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@mit.edu>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com
Subject: Re: [PATCH 30/30] x32: Add x32 VDSO support
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-31-git-send-email-hpa@zytor.com> <4F42E171.9080005@mit.edu>
In-Reply-To: <4F42E171.9080005@mit.edu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 04:12 PM, Andy Lutomirski wrote:
> 
> Would it make sense to remove the non-__vdso-prefixed weak symbols?
> AFAICT they are somewhere between useless (because the __vdso symbols
> are unambiguous), confusing (has anyone not read this and said "huh?"),
> and wrong (they are not interchangeable with glibc's symbols as they
> return different values).
> 
> We're stuck with them on x86-64, but x32 is new and has no
> backwards-compatibility issues.
> 

What about non-glibc?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

