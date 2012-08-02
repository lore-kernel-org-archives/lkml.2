Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2HBQkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:40:51 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48186 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2HBQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:40:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Tejun Heo <tj@kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
References: <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com>
	<20120801182112.GC15477@google.com> <50197460.8010906@gmail.com>
	<20120801182749.GD15477@google.com> <50197E4A.7020408@gmail.com>
	<20120801202432.GE15477@google.com> <5019B0B4.1090102@gmail.com>
	<20120801224556.GF15477@google.com> <501A4FC1.8040907@gmail.com>
	<20120802103244.GA23318@leaf> <501A633B.3010509@gmail.com>
	<87txwl1dsq.fsf@xmission.com> <501AAC26.6030703@gmail.com>
Date: Thu, 02 Aug 2012 09:40:38 -0700
In-Reply-To: <501AAC26.6030703@gmail.com> (Sasha Levin's message of "Thu, 02
	Aug 2012 18:34:46 +0200")
Message-ID: <87fw851c3d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+4CkyO8r7wQlaBiMCNu00yVgrLUTNyoZ8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <levinsasha928@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> Heh, I've started working on it in April, and just returned to this. Didn't think about rebasing to something new.
>
> will fix - Thanks!

You might want to look at some of the work that Eric Dumazet has done in
the networking stack with rcu hashtables that can be resized.

For a trivial hash table I don't know if the abstraction is worth it.
For a hash table that starts off small and grows as big as you need it
the incent to use a hash table abstraction seems a lot stronger.

Eric
