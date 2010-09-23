Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0IWMfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:35:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:48027 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214Ab0IWMf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:35:29 -0400
Message-ID: <4C9B495D.70200@parallels.com>
Date: Thu, 23 Sep 2010 16:34:37 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: hadi@cyberus.ca, "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] net: Implement socketat.
References: <m1ocborgq7.fsf@fess.ebiederm.org>	 <m1bp7oq1u8.fsf@fess.ebiederm.org>  <4C9B162E.7040201@parallels.com>	 <1285240797.5036.5.camel@bigi>  <4C9B3B06.900@parallels.com>	 <1285242055.5036.9.camel@bigi>  <4C9B3F9C.8080506@parallels.com> <1285243881.5036.22.camel@bigi>
In-Reply-To: <1285243881.5036.22.camel@bigi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 04:11 PM, jamal wrote:
> On Thu, 2010-09-23 at 15:53 +0400, Pavel Emelyanov wrote:
> 
>> Why does it matter? You told, that the usage scenario was to
>> add routes to container. If I do 2 syscalls instead of 1, is
>> it THAT worse?
>>
> 
> Anything to do with socket IO that requires namespace awareness
> applies for usage; it could be tcp/udp/etc socket. If it doesnt
> make any difference performance wise using one scheme vs other
> to write/read heavy messages then i dont see an issue and socketat
> is redundant.

That's what my point is about - unless we know why would we need it
we don't need it.

Eric, please clarify, what is the need in creating a socket in foreign
net namespace?
