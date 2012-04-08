Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2DHWs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:48:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57338 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab2DHWs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:48:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<CAFLxGvwyx6S6+eZtR=UNSQe_O+W7oZW=GosseL54HGpjtYGXjg@mail.gmail.com>
	<m1iph9ewsy.fsf@fess.ebiederm.org>
	<CAFLxGvwHtA028V2XudM-5HXmXCPw5ENL5E_nHKZh_gbrsRV69g@mail.gmail.com>
Date: Sun, 08 Apr 2012 15:52:15 -0700
In-Reply-To: <CAFLxGvwHtA028V2XudM-5HXmXCPw5ENL5E_nHKZh_gbrsRV69g@mail.gmail.com>
	(richard's message of "Mon, 9 Apr 2012 00:04:56 +0200")
Message-ID: <m1zkaldeg0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19mrZD5nzx0izl//+lX0YOVu7/BDxYIzuc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;richard -rw- weinberger <richard.weinberger@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: [REVIEW][PATCH 0/43] Completing the user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger <richard.weinberger@gmail.com> writes:

> On Sun, Apr 8, 2012 at 11:30 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> richard -rw- weinberger <richard.weinberger@gmail.com> writes:
>
> Yep. Sounds great!
> I'll give your patch set a try within the next few days on my LXC
> testbed. :-)

Sounds good.

The big practical detail to work out is all of the userspace bits for
the uid and gid mappings.  Assigning multiple uids per each user and
things like that.  Which I expect ultimately means updating the shadow
package to set it up so that we reserve a bunch of uids and gids for
each user when their accounts are added.

Eric

