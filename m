Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2ITNOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:14:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35444 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2ITNN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:13:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <877grox6ql.fsf@xmission.com>
	<1348141326-23355-1-git-send-email-ebiederm@xmission.com>
	<1348141326-23355-20-git-send-email-ebiederm@xmission.com>
	<20120920125020.GD19648@localhost>
Date: Thu, 20 Sep 2012 06:13:52 -0700
In-Reply-To: <20120920125020.GD19648@localhost> (Bob Copeland's message of
	"Thu, 20 Sep 2012 08:50:20 -0400")
Message-ID: <87obl0vnu7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19R0Dy8K0m0vqF7vr5y2XQyQtvx4oLW/i8=
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
X-Spam-Combo: *;Bob Copeland <me@bobcopeland.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 20/25] userns: Convert omfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland <me@bobcopeland.com> writes:

> On Thu, Sep 20, 2012 at 04:42:01AM -0700, Eric W. Biederman wrote:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> Cc: Bob Copeland <me@bobcopeland.com>
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> Thanks, looks good to me.

Then I will take that as an Acked-by. ;)

Eric

