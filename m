Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2L0SwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:52:01 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56815 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2L0Sv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:51:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <87han82tm4.fsf@xmission.com>
	<CA+55aFzBYyCVyxaejHf-EMNq6-wEh7FuowBa7UjyQfVb8dY+Zw@mail.gmail.com>
Date: Thu, 27 Dec 2012 10:51:12 -0800
In-Reply-To: <CA+55aFzBYyCVyxaejHf-EMNq6-wEh7FuowBa7UjyQfVb8dY+Zw@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 27 Dec 2012 10:45:05 -0800")
Message-ID: <87d2xvpbvj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18pg0AWCgd/0ld2qltOsczHlBmXjQpEyEg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace fixes for v3.8-rc2
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Dec 26, 2012 at 5:04 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> Linus,
>>
>> Please pull the for-linus git tree from:
>>
>>    git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus
>
> Ugh. Can you please fix whatever script generates these bogus
> addresses? There's an extra colon there.

Doh!

I'm on it.

Eric

