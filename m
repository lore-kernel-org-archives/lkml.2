Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2GZRYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:24:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39792 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2GZRYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:24:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aristeu Rozanski <aris@ruivo.org>
Cc: aris@redhat.com, linux-kernel@vger.kernel.org
References: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
	<20120725161120.GA5478@cathedrallabs.org>
	<87wr1r77ry.fsf@xmission.com>
	<20120726171321.GE14574@cathedrallabs.org>
Date: Thu, 26 Jul 2012 10:24:41 -0700
In-Reply-To: <20120726171321.GE14574@cathedrallabs.org> (Aristeu Rozanski's
	message of "Thu, 26 Jul 2012 13:13:21 -0400")
Message-ID: <87hasu306e.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/l8IF1iUcVKoxTs5YDD7F+hoAVzq6w0vk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Aristeu Rozanski <aris@ruivo.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/5] userns: convert some filesystems to kuid/kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Rozanski <aris@ruivo.org> writes:

> Hi Eric,
> On Wed, Jul 25, 2012 at 04:14:41PM -0700, Eric W. Biederman wrote:
>> Sorry no.  I have unfortunately been a bit out of it for the last few
>> weeks and I have patches to address this already in my development tree.
>
> what's the tree you're using for development? ebiederm/user-namespace.git at
> kernel.org doesn't have those changes.

Please see my userns-always-map-user-v41 branch.

Eric

