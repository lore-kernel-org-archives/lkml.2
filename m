Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1E0SgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:36:01 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60951 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1E0SgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:36:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: prasad@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        crash-utility@redhat.com, Andi Kleen <andi@firstfloor.org>,
        "Luck\, Tony" <tony.luck@intel.com>, kexec@lists.infradead.org,
        anderson@redhat.com, Wang Chao <wang.chao@cn.fujitsu.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
References: <20110526170722.GB23266@in.ibm.com>
	<20110526172618.GB18295@in.ibm.com> <m11uzk80vx.fsf@fess.ebiederm.org>
	<20110527182210.GH8053@redhat.com>
Date: Fri, 27 May 2011 11:35:53 -0700
In-Reply-To: <20110527182210.GH8053@redhat.com> (Vivek Goyal's message of
	"Fri, 27 May 2011 14:22:10 -0400")
Message-ID: <m1hb8g6lfa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19d91B8OscEGH4nuCaQHRPxuVt76ppxU8I=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.0 XMSlimDrugH Weight loss drug headers
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC Patch 6/6] Crash: Recognise slim coredumps and process new elf-note sections
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, May 27, 2011 at 11:16:34AM -0700, Eric W. Biederman wrote:
>> "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
>> 
>> > Crash: Recognise slim coredumps and process new elf-note sections
>> >
>> > The Linux kernel will begin to support SlimDump for certain types of crashes
>> > and the 'crash' tool needs to recognise them. For these types of coredumps, it
>> > need not lookout for usual elf-structures and start gdb. Also process new
>> > elf-note sections that contain additional information about the crash.
>> 
>> I suppose patching crash make sense.
>> 
>> Unfortunately crash doesn't work on  99% of the  kernels I run so, so I
>> stopped caring a while ago.
>
> Are these patched kernels? Otherwise Dave Anderson is pretty good about
> keeping crash running across multiple kernels.

Only slightly patched.  But they are definitely kernels I have built
myself.  It might just be a logistics problem where if I want to use
crash I need to upgrade it when I upgrade my kernels.

I got frustrated a while ago trying to get something out of crash
(and I'm afraid it shows), and I have just gone to extracting the
dmesg.  Which gives me all of the information I generally have time
to process.

Eric
