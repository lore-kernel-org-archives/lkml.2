Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2LQVCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:02:12 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34939 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2LQVCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:02:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>
References: <87txroxpgq.fsf@xmission.com>
	<CALCETrX2Fa-DuM+wkgsij7oiJXzCD8W6Phkv-MjgCDg_Ma6CTg@mail.gmail.com>
Date: Mon, 17 Dec 2012 13:01:59 -0800
In-Reply-To: <CALCETrX2Fa-DuM+wkgsij7oiJXzCD8W6Phkv-MjgCDg_Ma6CTg@mail.gmail.com>
	(Andy Lutomirski's message of "Mon, 17 Dec 2012 11:03:10 -0800")
Message-ID: <87zk1cjsu0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+vp2OtOJMed0GECO5zpkusI0uIDzRcEY8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/4] user namespace fixes
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Fri, Dec 14, 2012 at 2:01 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> These are fixes from Andys review of my user namespace tree.
>>
>> The first two patches are critical must fix fixes.
>>
>> The third patch fixing commit_creds is a nice to have but fixing it
>> would be good.
>>
>> Andy, Serge  if you could give these patches a once over to make certain
>> I am not doing something stupid.
>>
>> Thank you,
>> Eric
>>
>> ---
>>
>> Eric W. Biederman (4):
>>       Fix cap_capable to only allow owners in the parent user namespace to have caps.
>
> For whatever reason, I didn't get the actual email. 

How weird.

> Assuming this is
> 5e4a08476b50fa39210fca82e03325cc46b9c235:

It is the parent of that 5e4a08476b50fa39210fca82e03325cc46b9c235
520d9eabce18edfef76a60b7b839d54facafe1f9

But that should be close enough.

> Acked-by: Andy Lutomirski <luto@amacapital.net>

Eric
