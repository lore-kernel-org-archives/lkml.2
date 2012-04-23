Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2DWU2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:28:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48758 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2DWU2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:28:50 -0400
Date: Mon, 23 Apr 2012 15:28:39 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH resend v3] x86: memtest: WARN if bad RAM found
Message-ID: <20120423202839.GA14147@burratino>
References: <20120402150522.GA4980@burratino>
 <20120413193905.GD2387@burratino>
 <20120423182630.GA13067@burratino>
 <CAE9FiQVSdnqrno4VBZbcQmcYagpXPOo_Cvw=c9w_1GZycKv1Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAE9FiQVSdnqrno4VBZbcQmcYagpXPOo_Cvw=c9w_1GZycKv1Xg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Mon, Apr 23, 2012 at 11:26 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:

>> --- a/arch/x86/mm/memtest.c
>> +++ b/arch/x86/mm/memtest.c
>> @@ -30,6 +30,8 @@ static u64 patterns[] __initdata = {
>>
>>  static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
>>  {
>> +       WARN_ONCE(1, "Bad RAM detected. Use memtest86+ to perform a thorough test\n"
>> +                 "and the memmap= parameter to reserve the bad areas.");
>
> You must be kidding : calling memtest86+ "thorough test".

How about "more thorough test"?  Or do you have a better
recommendation for users?

Thanks for looking it over.
Jonathan
