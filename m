Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab2LGW5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:57:00 -0500
Received: from [198.137.202.10] ([198.137.202.10]:42866 "EHLO mail.zytor.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab2LGW47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:56:59 -0500
Message-ID: <50C27410.7050101@zytor.com>
Date: Fri, 07 Dec 2012 14:56:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/tools/gen-insn-attr-x86.awk: remove duplicate
 const
References: <1354920151-4461-1-git-send-email-dinggnu@gmail.com> <3c1e54bc-31ec-4a38-b6d3-58b25760f9cb@email.android.com> <20121207224949.GA6179@gmail.com>
In-Reply-To: <20121207224949.GA6179@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 02:49 PM, Cong Ding wrote:
> On Fri, Dec 07, 2012 at 02:45:43PM -0800, H. Peter Anvin wrote:
>> Patch description please?
> there are 2 consts in the definition of one variable
>

Please put in an actual patch description.  The first line (subject 
line) is a title; the patch should make sense without it.

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

