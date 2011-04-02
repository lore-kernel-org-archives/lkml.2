Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1DBWV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 18:21:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35503 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1DBWV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 18:21:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: sedat.dilek@gmail.com, Florian Mickler <florian@mickler.org>,
        Paul Bolle <pebolle@tiscali.nl>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, zersaa@gmail.com,
        stable@kernel.org
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
	<1301561386.1904.15.camel@t41.thuisdomein>
	<20110331125305.1e8c70ba@schatten.dmk.lab>
	<AANLkTikmWDu7FZ2A7_CWGCuAeKOeK4x+u8vctCro0mSN@mail.gmail.com>
	<m1ipuzfqb9.fsf@fess.ebiederm.org> <20110331124327.GA20112@elte.hu>
	<m1vcyxeavf.fsf@fess.ebiederm.org> <20110402184314.GA17191@elte.hu>
Date: Sat, 02 Apr 2011 15:21:39 -0700
In-Reply-To: <20110402184314.GA17191@elte.hu> (Ingo Molnar's message of "Sat,
	2 Apr 2011 20:43:14 +0200")
Message-ID: <m1r59ke1l8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Dngc+rFVAFMZBnSgOffE7Y/gRsXYrDfM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: lkml.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics are not present
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ingo Molnar <mingo@elte.hu> writes:
>> 
>> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
>> >
>> >> I don't have a clue why my patch got lost, [...]
>> >
>> > It was not lost, it broke the build. You were notified but never followed up 
>> > with a working patch:
>> >
>> >   https://lkml.org/lkml/2010/10/2/91
>> >
>> > and a different patch was applied to get rid of the warning messages. We can 
>> > apply your patch (and that patch can undo the other fix), but it has to build, 
>> > obviously.
>> 
>> Ingo any clue why I this message didn't make it to me directly but I
>> only received it through the linux-kernel?
>
> Hm, no idea - i did not receive any email bounce message.
>
> Did you get this one directly?

I did.  It looks like the gremlins in the network are at it again.
Thank you for looking.

Eric
