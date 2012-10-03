Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab2JCXie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:38:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38286 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab2JCXid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:38:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>
References: <87626r17l1.fsf@xmission.com> <20121003232510.GC14392@kroah.com>
Date: Wed, 03 Oct 2012 16:38:27 -0700
In-Reply-To: <20121003232510.GC14392@kroah.com> (Greg Kroah-Hartman's message
	of "Wed, 3 Oct 2012 16:25:10 -0700")
Message-ID: <87fw5vyvm4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19+3SakpwFm8eE2fWRbNSCOmBWsYCAulrM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] user namespace compile fix for 3.7
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Oct 03, 2012 at 04:03:54PM -0700, Eric W. Biederman wrote:
>> 
>> Linus,
>> 
>> Please pull the for-linus git tree from:
>> 
>>    git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus
>> 
>>    HEAD: 702e490211b2b7e448ebe1b3a07d97ad2fc07e03 userns: Fix build of drivers/staging/dgrp
>> 
>> This tree contains a trivial build fix for one of the staging drivers
>> when user namespace support is enabled.
>
> Is this something new?  Why didn't it show up in the linux-next builds?

Yes this appears to have been a silent merge conflict between my user
namespace tree and your staging tree.

I care because it breaks my builds.

This build failure only shows up when CONFIG_USER_NS is enabled which
would have required a randconfig build in linux-next for it to show up.

When I get the last of the filesystems converted for 3.8 this kind of
failure should stop hiding in the more customary build checks.

> I'll be glad to take this single patch myself and queue it up with other
> staging tree fixes before 3.7-final is out, what is the big rush?

I figured I found it, I fixed it, and I am going to be carrying the fix
anyway in my tree, so why not make it easy on everyone and make it a
patch that can be pulled.

Eric
