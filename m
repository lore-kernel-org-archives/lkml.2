Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2DXAM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:12:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42159 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2DXAMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:12:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
References: <20120423170701.c96e402234b1387dece11dda@canb.auug.org.au>
	<4F95828A.8050403@xenotime.net>
Date: Mon, 23 Apr 2012 17:16:56 -0700
In-Reply-To: <4F95828A.8050403@xenotime.net> (Randy Dunlap's message of "Mon,
	23 Apr 2012 09:25:46 -0700")
Message-ID: <m1vckqrnk7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18y6w6HJGh5RvJOEB7Nofc1GYYFKjfBbGM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  8.5 XMNoUri_00 BODY: domains not in uri format
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Randy Dunlap <rdunlap@xenotime.net>
X-Spam-Relay-Country: **
Subject: Re: linux-next: Tree for Apr 23 (ax.25 sysctl)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> writes:

> On 04/23/2012 12:07 AM, Stephen Rothwell wrote:
>
>> Hi all,
>> 
>> Changes since 20120420:
>
>
>
> include/net/ax25.h:447:75: error: expected ';' before '}' token
>
>
> static inline int ax25_register_dev_sysctl(ax25_dev *ax25_dev) { return 0 };
> static inline void ax25_unregister_dev_sysctl(ax25_dev *ax25_dev) {};
>
> Is this from Eric B.'s sysctl patches?

Sort of.  I made the function per device and return 0.

I missed the inner ';' when I made the change.  The outer '};' has
been there for years and has been weird but harmless.

Patch to fix it in a moment.

Eric


> First function:  move ';' inside braces.
> Second function:  drop the ';'.
