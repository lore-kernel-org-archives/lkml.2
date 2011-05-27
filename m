Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab1E0SBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:01:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54568 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab1E0SBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:01:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: prasad@linux.vnet.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck\, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        anderson@redhat.com
References: <20110526170722.GB23266@in.ibm.com>
	<20110526171251.GB17988@in.ibm.com>
Date: Fri, 27 May 2011 11:01:29 -0700
In-Reply-To: <20110526171251.GB17988@in.ibm.com> (K. Prasad's message of "Thu,
	26 May 2011 22:42:51 +0530")
Message-ID: <m1lixs9g5i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+QRli34SuuokokMmcdZD8MWyur7akgeBo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;prasad@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: [Patch 2/6] x86: mce: Convert mce code to xpanic
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K.Prasad" <prasad@linux.vnet.ibm.com> writes:

> commit aea29c4a9324f24b5c61e7c3919a8137a53be935
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Fri Nov 19 18:42:02 2010 +0100
>
>     x86: mce: Convert mce code to xpanic
>     
>     - Pass in the panic timeout directly instead of
>     abusing global variable.
>     - Disable backtraces and kexecs on machine check panics
>     because they don't do anything useful.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Kexec on panic does not fact do something useful, and usable
today.

The mce_panic_timeout looks like a horrible hack that should
be killed.  Why do we think we know better than the sysadmin
that sets up the system.

Eric
