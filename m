Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab0IYAF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 20:05:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44711 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab0IYAFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 20:05:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
	<20100924104555.GC1819@silverbox.local>
	<m1hbhfcbdo.fsf@fess.ebiederm.org>
	<20100924173106.GA4966@silverbox.local>
Date: Fri, 24 Sep 2010 17:05:17 -0700
In-Reply-To: <20100924173106.GA4966@silverbox.local> (Hans J. Koch's message
	of "Fri, 24 Sep 2010 19:31:07 +0200")
Message-ID: <m14ode662q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hans J. Koch" <hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/5] uio hotplug support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hans J. Koch" <hjk@linutronix.de> writes:

> On Fri, Sep 24, 2010 at 10:14:11AM -0700, Eric W. Biederman wrote:
>> "Hans J. Koch" <hjk@linutronix.de> writes:
>> 
>> > On Mon, Sep 20, 2010 at 12:19:59AM -0700, Eric W. Biederman wrote:
>> >> 
>> >> Implement the ability to hotunplug a uio device while file handles
>> >> are still open without crashing.
>> >
>> > Could you please create patches that apply on top of your already
>> > accepted UIO changes?
>> 
>> That is what the patches I sent should be.  My apologies if I had not
>> made that clear.  Certainly these patches were built against my previous
>> changes, on top of 2.6.36-rc4.  Are you having problems?
>
> Hmm, I applied your first series of 5 patches (which I signed-off). When
> trying to apply your second series, I get this from quilt:
>
> Applying patch 2_1-Simplify-the-lifetime-logic-of-struct-uio_device.patch
> patching file drivers/uio/uio.c
> Hunk #2 succeeded at 287 (offset 8 lines).
> Hunk #3 succeeded at 312 (offset 8 lines).
> Hunk #4 FAILED at 339.
> Hunk #5 succeeded at 806 (offset 17 lines).
> Hunk #6 FAILED at 831.
> Hunk #7 FAILED at 858.
> Hunk #8 FAILED at 889.
> 4 out of 8 hunks FAILED -- rejects in file drivers/uio/uio.c
> Patch 2_1-Simplify-the-lifetime-logic-of-struct-uio_device.patch does not apply (enforce with -f)
>
> The first series applied without any fuzz against 2.6.36-rc5.

I am stumped.  Do you perhaps have some local uio changes?

Using 2.6.36-rc5 as a base I tried it twice.  Once by taking my patches
that I sent, and again by saving my email and then applying the changes.

Both times the changes applied cleanly.  No offsets, and no fuzz.  At
least that is what git-am said.

Should I perhaps make a git branch you could pull?

Eric
