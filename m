Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2GBNGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:06:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33081 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2GBNG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:06:29 -0400
References: <1340280437-7718-1-git-send-email-bp@amd64.org> <20120630174503.GA24854@aftab.osrc.amd.com> <1341222838.23484.1.camel@twins>
User-Agent: K-9 Mail for Android
In-Reply-To: <1341222838.23484.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v2 0/2] x86, microcode: Reload ucode only per-system
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 02 Jul 2012 06:05:56 -0700
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@kernel.org>, X86-ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <29cea64a-e041-48ba-bf3e-0965740b862b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I put them into x86/microcode already.

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

>On Sat, 2012-06-30 at 19:45 +0200, Borislav Petkov wrote:
>> Assuming there are no more objections to those, can we get them into,
>> say, tip:x86/microcode for a wider, linux-next testing?
>> 
>> Peter's stuff could go there too or through the perf tree - it's
>kinda
>> arbitrary though. 
>
>I've got them queued as such, Ingo's just hasn't gotten around to
>picking things up yet. Let me see if today is a good day for this.. :-)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
