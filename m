Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab2LQEB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 23:01:26 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56931 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2LQEBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 23:01:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
References: <alpine.LRH.2.02.1212151925410.27388@tundra.namei.org>
	<CA+55aFxxC8xpG9KQtqxRfcJzCu58Fv711bTwtKFq3HHAvRhYBA@mail.gmail.com>
Date: Sun, 16 Dec 2012 20:01:14 -0800
In-Reply-To: <CA+55aFxxC8xpG9KQtqxRfcJzCu58Fv711bTwtKFq3HHAvRhYBA@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 16 Dec 2012 15:51:05 -0800")
Message-ID: <8738z5nx85.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+gJINr5P1y9MiOfgkIfqsgHEaIfFgngsQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_XMDrugObfuBody_00 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [GIT] Security subsystem updates for 3.8
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, Dec 15, 2012 at 12:28 AM, James Morris <jmorris@namei.org> wrote:
>> A quiet cycle for the security subsystem with just a few maintenance
>> updates.
>
> Ok, pulled. There were a few trivial conflicts (mostly due to some of
> the key allocation patches having already been merged, and some of the
> kuid/kgid changes due to the userns changes).
>
> I'd like you to double-check the end result, but it *looks* fine.
> Adding both EricB and DavidH to the participants since the conflicts
> were generally due to intetractions with their patches.

I just read through the conflict resolution and I don't see any
kuid/kgid problems.  I am surprised that there were any kuid/kgid
conflicts as all of my changes in that area were in 3.6-rc1.

Eric
