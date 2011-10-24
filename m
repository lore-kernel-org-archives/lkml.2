Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1JXE0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 00:26:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36624 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1JXE0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 00:26:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        oleg@redhat.com, richard@nod.at, mikevs@xs4all.net,
        segoon@openwall.com, gregkh@suse.de, dhowells@redhat.com,
        eparis@redhat.com, netdev@vger.kernel.org
References: <1318974898-21431-1-git-send-email-serge@hallyn.com>
	<1318974898-21431-10-git-send-email-serge@hallyn.com>
	<m1sjmpytpf.fsf@fess.ebiederm.org> <20111020125801.GA1315@hallyn.com>
	<m1fwinvl8u.fsf@fess.ebiederm.org> <20111020141440.GA6201@sergelap>
	<20111024041529.GA23618@hallyn.com>
Date: Sun, 23 Oct 2011 21:27:01 -0700
In-Reply-To: <20111024041529.GA23618@hallyn.com> (Serge E. Hallyn's message of
	"Mon, 24 Oct 2011 04:15:29 +0000")
Message-ID: <m1ehy3j9pm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Ma98MS+slKcMZUW17+gZdbnc0bHEmVEI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 9/9] make net/core/scm.c uid comparisons user namespace aware
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Never mind, it all gets a little convoluted, but I see how it works,
> and - when the time comes - how to do it right for userns.  :)  Sorry
> about that.

No problem.

Eric
