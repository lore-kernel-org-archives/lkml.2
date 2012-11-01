Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2KAKlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:41:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52115 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2KAKlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:41:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <508FDEF3.8030601@hitachi.com> <20121030143750.GF2290@redhat.com>
	<50912CFB.5000508@hitachi.com> <20121031141426.GE1865@redhat.com>
	<50924FCD.2020100@hitachi.com>
Date: Thu, 01 Nov 2012 03:40:56 -0700
In-Reply-To: <50924FCD.2020100@hitachi.com> (Mitsuhiro Tanino's message of
	"Thu, 01 Nov 2012 19:32:45 +0900")
Message-ID: <87vcdpk3lz.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19+/BO/sYC5ilXyJUEGvr3hKF/M4UisVog=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
X-Spam-Relay-Country: 
Subject: Re: [Patch 0/2] Exclude hwpoison page from vmcore dump
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com> writes:

> Hi Vivek,
>
> (2012/10/31 23:14), Vivek Goyal wrote:
>> If hwpoision functionality is not available in hardware, then respective
>> bit will not be even set in struct page and it will be saved by default.
>> So it should not matter whether hardware has hwpoision functionality
>> or not.
>
> Thanks, I understand.
>
>> I think that removing hwpoisno pages by default makes sense. If somebody
>> does have a reasonable case of not doing so, then we could either
>> introduce anther filtering level (based on type) or add another command
>> line option like (--no-hwposion-filtering) etc.
>
> I agree with you.
> If somebody requests to support for disabling the filter of hwpoison pages,
> this option will be discussed.


I agree.  If we are performing filtering filtering out of poisoned pages
seems very reasonable.  So ack on the basic concept.

Eric
