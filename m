Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab2JEWBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:01:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50485 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2JEWBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:01:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, Cliff Wickman <cpw@sgi.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<20121003165105.GA30214@jshin-Toonie>
	<CAE9FiQW7vcwSUen_TD8tZQd6aDU2-on5_T4Bjr6aqN1bxM_5Cg@mail.gmail.com>
	<20121004164630.GB2244@phenom.dumpdata.com>
	<CAE9FiQUBohwjOzOm26yJME=JzZ7eH55hM+Q=Kc4Pz+ocaw90Jg@mail.gmail.com>
	<871uhcsk93.fsf@xmission.com>
	<CAE9FiQVx93B_imGbs1ms7gcu_-Z9HvkcGePQi9XpWQo0SKu-Kg@mail.gmail.com>
	<87ehlcr4et.fsf@xmission.com>
	<CAE9FiQU_PSv6afXLcQ8ohrn1wqoVttO+u5MA5xBEE4jJRVx9Mw@mail.gmail.com>
	<877gr4r40b.fsf@xmission.com>
	<CAE9FiQUW3uvkooBxqEdSxV7T8h4=5qonoLbJCPGT0kTceqSNRw@mail.gmail.com>
Date: Fri, 05 Oct 2012 15:01:26 -0700
In-Reply-To: <CAE9FiQUW3uvkooBxqEdSxV7T8h4=5qonoLbJCPGT0kTceqSNRw@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 5 Oct 2012 14:43:57 -0700")
Message-ID: <87obkgpoi1.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19G8h4UQZgvtAcBQg0cXsbaotSAkUp924U=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
Subject: 896MB address limit (was: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am going to see about merging these two threads.

Yinghai Lu <yinghai@kernel.org> writes:

> On Fri, Oct 5, 2012 at 2:41 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> with bzImage or vmlinux?
>>
>> bzImage I presume.  Certainly the bzImage has lost it's 896M limit,
>> which is where ultimiately the 896M limite came from.
>
> they are using updated kexec-tools ?
>
> last time when i checked the code for kexec-tools
> found the 896M problem was from kexec-tools bzimage support.

Cliff Wickman was the guy at sgi running the tests.

To the best of my knowledge he was runing an up to date kexec-tools and
was loading a bzImage.  Of course his initial reaction was where did the
896M limit come from, as he had just updated to a kernel with the limit
a few weeks ago.

YH please talk to Cliff directly.

Eric

