Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2IZL1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:27:54 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56709 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2IZL1x convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 26 Sep 2012 07:27:53 -0400
Message-Id: <506302EE020000780009DF72@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 26 Sep 2012 12:28:14 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Tao Guo" <glorioustao@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: Work around old gas bug
References: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
 <5062F267020000780009DF06@nat28.tlf.novell.com>
 <20120926111610.GB21143@gmail.com>
In-Reply-To: <20120926111610.GB21143@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.09.12 at 13:16, Ingo Molnar <mingo@kernel.org> wrote:

> * Jan Beulich <JBeulich@suse.com> wrote:
> 
>> >>> On 26.09.12 at 10:28, Tao Guo <glorioustao@gmail.com> wrote:
>> > gas in binutils(2.16.91) could not parse parentheses within macro
>> > parameters unless fully parenthesized, and this is a workaround to
>> > make old gas work without generating below errors:
>> > arch/x86/kernel/entry_64.S: Assembler messages:
>> > arch/x86/kernel/entry_64.S:387: Error: too many positional arguments
>> > arch/x86/kernel/entry_64.S:389: Error: too many positional arguments
>> > arch/x86/kernel/entry_64.S:390: Error: too many positional arguments
>> > arch/x86/kernel/entry_64.S:391: Error: too many positional arguments
>> > arch/x86/kernel/entry_64.S:392: Error: too many positional arguments
>> > arch/x86/kernel/entry_64.S:393: Error: too many positional arguments
>> > arch/x86/kernel/entry_64.S:394: Error: too many positional arguments
>> > 
>> > Signed-off-by: Tao Guo <glorioustao@gmail.com>
>> 
>> This looks okay now to me, but I'm somewhat reluctant to 
>> formally ack it given that we know how broken those particular 
>> gas versions are.
> 
> Well, assuming Tao Guo test-booted a kernel build with this old 
> GAS version, we could apply this patch on a best-effort basis - 
> the changes don't look particularly ugly. If other, unacceptable 
> uglies or fragilities come up then we might balk.
> 
> Agreed?

Fine with me.

Jan

