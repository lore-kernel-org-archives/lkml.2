Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0LHXUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:20:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51063 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0LHXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:20:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
References: <20101201195835.GE2511@redhat.com>
	<1291234036.32004.2008.camel@laptop>
	<m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	<1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>
	<1291764620.2032.1293.camel@laptop>
	<20101208140103.GM21786@redhat.com> <1291818005.28378.38.camel@laptop>
	<1291820356.28378.83.camel@laptop> <20101208223746.GR21786@redhat.com>
Date: Wed, 08 Dec 2010 15:20:37 -0800
In-Reply-To: <20101208223746.GR21786@redhat.com> (Don Zickus's message of
	"Wed, 8 Dec 2010 17:37:46 -0500")
Message-ID: <m1oc8vetru.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+uZVHmR2EUhRVDumd57aCBCfqLSt/QVxs=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Don Zickus <dzickus@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: perf hw  in kexeced kernel broken in tip
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> On Wed, Dec 08, 2010 at 03:59:16PM +0100, Peter Zijlstra wrote:
>> On Wed, 2010-12-08 at 15:20 +0100, Peter Zijlstra wrote:
>> 
>> > > I wonder if you should reverse these checks.  If the bios has the perf
>> > > counter enabled, there might be a high chance that it fails the first
>> > > check and never gets to the actually bios checks.
>> > 
>> > Ah, good point. 
>> 
>> Something like so..
>
> This seems to work correctly on my Nehalem and broken bios machines during
> boot and kexec.  As expected it fails during kdump.  My p4 box failed
> during kexec for some reason.  But p4 has other issues.

Does the kdump kernel still boot?

It looks like it should I just want to double check.

Eric
