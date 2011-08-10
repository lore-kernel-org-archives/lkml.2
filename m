Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1HJRW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:22:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47365 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab1HJRW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:22:56 -0400
Message-ID: <4E42BDFF.5060507@zytor.com>
Date: Wed, 10 Aug 2011 12:21:03 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@mit.edu>
CC: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/3] x86-64: Rework vsyscall emulation and add vsyscall=
 parameter
References: <cover.1312988155.git.luto@mit.edu> <8449fb3abf89851fd6b2260972666a6f82542284.1312988155.git.luto@mit.edu>
In-Reply-To: <8449fb3abf89851fd6b2260972666a6f82542284.1312988155.git.luto@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 10:15 AM, Andy Lutomirski wrote:
> There are three choices:
> 
> vsyscall=native: Vsyscalls are native code that issues the
> corresponding syscalls.
> 
> vsyscall=emulate (default): Vsyscalls are emulated by instruction
> fault traps, tested in the bad_area path.  The actual contents of
> the vsyscall page is the same as the vsyscall=native case except
> that it's marked NX.  This way programs that make assumptions about
> what the code in the page does will not be confused when they read
> that code.
> 
> vsyscall=none: Trying to execute a vsyscall will segfault.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>

Hi Andy,

This patch doesn't apply.  What is your baseline for this patch?

	-hpa

