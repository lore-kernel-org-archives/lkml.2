Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2DMX7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 19:59:10 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34892 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2DMX7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 19:59:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, ericvh@gmail.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        levinsasha928@gmail.com, remi.denis-courmont@nokia.com
References: <CA+1xoqdi4QOhRJvBA64pxiN3EphhThjPkf4eLRkYM8jxcJjh=w@mail.gmail.com>
	<m1mx6otk85.fsf@fess.ebiederm.org>
	<m1aa2otjf4.fsf_-_@fess.ebiederm.org>
	<20120413.110505.1391379079973352104.davem@davemloft.net>
Date: Fri, 13 Apr 2012 17:03:00 -0700
In-Reply-To: <20120413.110505.1391379079973352104.davem@davemloft.net> (David
	Miller's message of "Fri, 13 Apr 2012 11:05:05 -0400 (EDT)")
Message-ID: <m18vhz6uyz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+T4ZYQJYY0HWhXWixYn1g1n9beDatf0LM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] net: In unregister_netdevice_notifier unregister the netdevices.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Fri, 06 Apr 2012 18:33:35 -0700
>
>>>From a51fda849355b2ffb27cdb5d66fa1a96e7f47335 Mon Sep 17 00:00:00 2001
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> Date: Sun, 25 Dec 2011 19:39:52 -0800
>> Subject: 
>
> Yikes, I had to edit this turd out :-)  Otherwise with this empty
> Subject, GIT uses the first line of your commit log body as the
> first line.

Ugh.  I usually do.  I think I was tired that day.

>> We already synthesize events in register_netdevice_notifier and synthesizing
>> events in unregister_netdevice_notifier allows to us remove the need for
>> special case cleanup code.
>> 
>> This change should be safe as it adds no new cases for existing callers
>> of unregiser_netdevice_notifier to handle.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> Applied.

Thanks,

Eric

