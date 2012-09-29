Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2I2PFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 11:05:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab2I2PFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 11:05:42 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20120929104611.GB14974@khazad-dum.debian.net>
References: <1347039854.6288.8.camel@thor> <504A3FA9.1050502@zytor.com> <504D6490.2060606@oracle.com> <1348853876.2229.22.camel@thor> <5066680E.3090907@zytor.com> <20120929104611.GB14974@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to cleanup
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 29 Sep 2012 08:05:15 -0700
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Peter Hurley <peter@hurleysoftware.com>,
        "zhenzhong.duan@oracle.com" <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <30701c46-a57e-49f2-9273-6f725c8463e0@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PAT support are lacking only in the Pentium Pro and Pentium II.  Sorry, if you're using crap that old, you don't get to screw up the kernel for everyone else.

Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

>On Fri, 28 Sep 2012, H. Peter Anvin wrote:
>> On 09/28/2012 10:37 AM, Peter Hurley wrote:
>> > An interesting side note: more recent revisions of this BIOS (rev.
>A11)
>> > report one less variable MTRR (so, IA32_MTRRCAP is writable?)
>> > 
>> >>> However, the right way to fix that is to use the PAT interfaces,
>which 
>> >>> doesn't have this drawback -- then MTRR cleanup becomes entirely 
>> >>> superfluous and the problem goes away.
>> >> Do you mean disable MTRR totally here?
>> > 
>> > Well, since PAT entries marked WC override all MTRR settings,
>whatever
>> > the BIOS set the variable MTRRs to becomes irrelevant, so not
>disabled
>> > but rather ignored.
>> > 
>> 
>> The whole point is that the display stuff should not use MTRR, but
>> rather use PAT to provide WC.  Then we don't need to "clean up" the
>> BIOS-set MTRRs.
>
>What about my trusty ThinkPad T43, and other ia32 boxes that either
>lack PAT
>support, or have it blacklisted?
>
>These are exactly the boxes that will _never_ get a BIOS fix if their
>MTRRs
>are screwed up...

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
