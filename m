Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab2GYXOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:14:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:42304 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2GYXOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:14:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aristeu Rozanski <aris@ruivo.org>
Cc: aris@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20120725161120.GA5478@cathedrallabs.org> (Aristeu Rozanski's
	message of "Wed, 25 Jul 2012 12:11:20 -0400")
References: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
	<20120725161120.GA5478@cathedrallabs.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Wed, 25 Jul 2012 16:14:41 -0700
Message-ID: <87wr1r77ry.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/eZMh+tSr1CPKfOtKWJwqGwjaf/OhNuro=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Aristeu Rozanski <aris@ruivo.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/5] userns: convert some filesystems to kuid/kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Rozanski <aris@ruivo.org> writes:

> Hi Eric,
> On Wed, Jul 11, 2012 at 03:01:17PM -0400, Aristeu Rozanski wrote:
>> Hi,
>> this patchset converts 9p, ADFS, AFFS, AFS and autofs4 to use kuid and kgid.
>> I plan to work on the other pending filesystems too but wanted some feedback
>> on the first ones first.
>
> had any chance to look at these?

Sorry no.  I have unfortunately been a bit out of it for the last few
weeks and I have patches to address this already in my development tree.

Eric

