Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2KTRQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:16:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55912 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2KTRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:16:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sage Weil <sage@inktank.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
References: <87pq38wimv.fsf@xmission.com>
	<1353415420-5457-1-git-send-email-ebiederm@xmission.com>
	<1353415420-5457-3-git-send-email-ebiederm@xmission.com>
	<alpine.DEB.2.00.1211200847110.7369@cobra.newdream.net>
Date: Tue, 20 Nov 2012 09:15:51 -0800
In-Reply-To: <alpine.DEB.2.00.1211200847110.7369@cobra.newdream.net> (Sage
	Weil's message of "Tue, 20 Nov 2012 08:48:00 -0800 (PST)")
Message-ID: <876250ry9k.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+kxLMXn50jkZ0mLYo/4V0NGcMcp4YEJtM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Sage Weil <sage@inktank.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH RFC 03/12] userns: Convert ceph to use kuid/kgid where appropriate
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil <sage@inktank.com> writes:

> On Tue, 20 Nov 2012, Eric W. Biederman wrote:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> Cc: Sage Weil <sage@inktank.com>
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> Acked-by: Sage Weil <sage@inktank.com>
>
> Do you want me to take this via the ceph tree?

If you have reviewed the changes, understand them and don't have
problems with them, having the changes go through your tree would be
great.

Eric
