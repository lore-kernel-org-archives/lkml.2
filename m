Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab2EKXQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:16:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39179 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab2EKXQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:16:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>, <linux-kernel@vger.kernel.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
Date: Fri, 11 May 2012 16:20:54 -0700
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sat, 07 Apr 2012 22:10:28 -0700")
Message-ID: <m1likyz4mh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+CMX8GdF6ez4sm0Db2V+yw08JOWTOC97w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: **
Subject: Please include user-namespace.git in linux-next
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In linux-next please include git://pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-next

This tree includes the fixed versions of the 43 patches I sent out for
review a few weeks ago, plus an updated Kconfig options so the parts
that won't build can't build can't be selected making allyesconfig and
allnoconfig safe.

The discussion of this work was covered in lwn at:
http://lwn.net/Articles/491310

There are a bunch more trivial patches to go that still need to be
reviewed but the core has been reviewed and tested left/right up/down
and sideways and it looks like all of the bugs have fallen out.

Eric


