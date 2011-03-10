Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1CJT57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:57:59 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:40293 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1CJT56 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-jbeulich@novell.com:7:1>);
	Thu, 10 Mar 2011 14:57:58 -0500
Message-Id: <4D792D41020000780006C482@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 10 Mar 2011 19:57:52 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <hjl.tools@gmail.com>
Cc: <psomas@cslab.ece.ntua.gr>, <heukelum@fastmail.fm>,
        <sedat.dilek@gmail.com>, <sedat.dilek@googlemail.com>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: linux-next: Tree for March 8 (BROKEN:
	 arch/x86/kernel/entry_32.S? (Offensive Word Found In Message)
	 Debian's binutils/as?)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H.J. Lu"  03/09/11 8:05 PM >>>
>On Wed, Mar 9, 2011 at 8:02 AM, Ingo Molnar  wrote:
>> I'm not denying that it's buggy code - I'm just asking you to *PLEASE* at minimum
>> acknowledge that surprise flag days that turn a before-benign condition into a fatal
>> build failure suck to everyone else outside your own little universe.
>>
>
>There is no way for assembler to know if a bug in input source code is
>"benign" or
>not. For assembler, a bug in input is a bug in input.  Assembly programmers
>should appreciate this assembler change for helping him/her catch such bugs
>in his/her codes.

I can only support Ingo here, particularly since the bug fixed in gas
is very unlikely to affect functionality of anyone's code - it's rather
that debuggability would have suffered. Clearly, as Ingo says, a
warning would have been enough for the next couple of years (in
my opinion, actually forever for that very reason), or at least a
diagnostic that's an error by default and can be turned into a
warning by the user. After all, it's not like the assembler couldn't
continue past that point (it can simply ignore the bogus directive),
but it ought to be only that condition which should cause an error.

Jan

