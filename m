Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab2JDRaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:30:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45772 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab2JDRaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:30:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
	<CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
	<20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
	<CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
	<506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
	<3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
	<CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
	<CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
Date: Thu, 04 Oct 2012 10:29:51 -0700
In-Reply-To: <CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
	(Kay Sievers's message of "Thu, 4 Oct 2012 04:39:57 +0200")
Message-ID: <87zk42tab4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+c2gPSeAdz26KMULegSY4aLZUtFPYoLBw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay@vrfy.org>
X-Spam-Relay-Country: 
Subject: Re: udev breakages -
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay@vrfy.org> writes:

> If that works out, it would a bit like devtmpfs which turned out to be
> very simple, reliable and absolutely the right thing we could do to
> primarily mange /dev content.

ROFL.

There are still quite a few interesting cases that devtmpfs does not
even think about supporting.  Cases that were reported when devtmpfs was
being reviewed. 

Additionally the devtmpfs maintainership has not dealt with legitimate
concerns any better than this firmware issue has been dealt with.  I
still haven't even hear a productive suggestion back on the hole
/dev/ptmx mess.

As it happens devtmpfs wound up being a userspace process that happens
to reside in the kernel and call mknod.  How it makes sense two layers
of messaging and device management instead of just one I don't know.
Certainly I would not crow about that being a success of anything except
passing the buck.

There is debacle written all over the user space interface for dealing
with devices right now.

Eric
