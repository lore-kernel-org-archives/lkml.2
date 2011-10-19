Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1JSVgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:36:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41321 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab1JSVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:36:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        htejun@gmail.com, fubar@us.ibm.com, andy@greyhouse.net
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
	<20111019.000932.523712028439316177.davem@davemloft.net>
Date: Wed, 19 Oct 2011 06:27:25 -0700
In-Reply-To: <20111019.000932.523712028439316177.davem@davemloft.net> (David
	Miller's message of "Wed, 19 Oct 2011 00:09:32 -0400 (EDT)")
Message-ID: <m18voh158i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18QAVpp4tnYUtX4w5LdLJmzuzIsmYYLr4w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 DATE_IN_PAST_06_12 Date: is 6 to 12 hours before Received: date
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 0/5] Better namespace handling for /sys/class/net/bonding_masters
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Thu, 13 Oct 2011 00:47:46 -0700
>
>> Greg, Dave I'm don't know whose tree to merge this through as this code
>> is equally device-core and networking.  I am hoping that we can get this
>> improvement merged for 3.2.
>
> I'm happy to take this series into my net-next tree.
>
> Greg?  Any objections?

on the 13th Greg said:

> These all look fine to me, and I have no problem with them going through
> the network tree as that will most likely be the easiest way due to any
> potential merge issues.
> 
> David, feel free to add an:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> to these patches and take them through your tree if that is ok with you.
> If not, I can also always take them through mine, it's your choice.

Eric
