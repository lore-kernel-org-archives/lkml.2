Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab2IMCPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 22:15:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:59241 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2IMCPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 22:15:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
References: <87lih2h6i4.fsf@xmission.com> <87mx1iecwi.fsf@xmission.com>
	<CAPM=9ty=0=+w8VaFC9QhajUkYwmym_JaWR9sbwmgw5tCKg5nGw@mail.gmail.com>
Date: Wed, 12 Sep 2012 19:14:55 -0700
In-Reply-To: <CAPM=9ty=0=+w8VaFC9QhajUkYwmym_JaWR9sbwmgw5tCKg5nGw@mail.gmail.com>
	(Dave Airlie's message of "Thu, 13 Sep 2012 11:31:36 +1000")
Message-ID: <87ligefz34.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18KYFflSIiqzSVbqQ7DGyoOouYmSZDb1Tg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0454]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Dave Airlie <airlied@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 12/15] userns: Convert drm to use kuid and kgid and struct pid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@gmail.com> writes:

>> Blink Blink this had not been converted to use struct pid ages ago?
>>
>> - On drm open capture the openers kuid and struct pid.
>> - On drm close release the kuid and struct pid
>> - When reporting the uid and pid convert the kuid and struct pid
>>   into values in the appropriate namespace.
>>
>
> Hi Eric,
>
> I'm fine with this seems okay, do you want me to merge it via
> drm-next?

My plan is to merge it via my user namespace tree.  And since you have
responed positively I will add your acked-by.  There are some nice
synergies when I get all of the changes in one tree.

If for some reason you want to carry this in your drm tree we can work
something out.

In this case I expect the change isn't big enough to worry about.

Eric
