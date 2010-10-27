Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab0J0Afs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:35:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53917 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab0J0Afp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:35:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: hadi@cyberus.ca
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	<m1bp7oq1u8.fsf@fess.ebiederm.org> <4C9B162E.7040201@parallels.com>
	<1285240797.5036.5.camel@bigi> <4C9B3B06.900@parallels.com>
	<1285242055.5036.9.camel@bigi> <4C9B3F9C.8080506@parallels.com>
	<4CA7A07C.5030504@free.fr> <1286113441.3812.229.camel@bigi>
	<1287145855.3642.30.camel@bigi> <1288126326.2094.131.camel@mojatatu>
Date: Tue, 26 Oct 2010 17:27:47 -0700
In-Reply-To: <1288126326.2094.131.camel@mojatatu> (jamal's message of "Tue, 26
	Oct 2010 16:52:06 -0400")
Message-ID: <m1aam032f0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;hadi@cyberus.ca
X-Spam-Relay-Country: 
Subject: Re: netns patches WAS( Re: [PATCH 8/8] net: Implement socketat.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jamal <hadi@cyberus.ca> writes:

> Eric,
>
> Ping?
> If you are too busy to push these in maybe have
> someone clueful like Daniel help out submitting? I think it
> should probably be reasonable to leave out the sockeat
> patch initially if it is deemed controversial..

This merge cycle I am too busy, and my patches did not make it into
linux-next before the merge window.

Everything except socketat at seems non-controversial.  socketat makes
sense to post-pone a little bit until we start converting applications,
and there is a little real world experience about what is needed.

I anticipate some time freeing up in the next couple of weeks so I
should be ready for the next merge window.

Eric
