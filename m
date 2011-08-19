Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1HSIv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 04:51:59 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57255 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1HSIv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 04:51:58 -0400
Message-ID: <4E4E2427.9080602@nod.at>
Date: Fri, 19 Aug 2011 10:51:51 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 00/91] pending uml patches
References: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk> <4E4D642F.3010909@nod.at> <20110818191946.GW2203@ZenIV.linux.org.uk> <20110819043120.GY2203@ZenIV.linux.org.uk>
In-Reply-To: <20110819043120.GY2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.08.2011 06:31, schrieb Al Viro:
> On Thu, Aug 18, 2011 at 08:19:46PM +0100, Al Viro wrote:
>> On Thu, Aug 18, 2011 at 09:12:47PM +0200, Richard Weinberger wrote:
>>> Have you touched your patches since yesterday?
>>> I've already pulled and uploaded them to my shiny new git repo at:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/rw/linux-um.git unstable
>>
>> Reordered and added missing S-o-b on a couple, split one commit.
>
> Umm...  One comment after looking at your tree: you probably want to rebase
> for-3.2 on top of fixes (and presumably feed it to sfr for inclusion into
> linux-next).

Please slow down a bit. :-)
All these branches are just for testing purposes.
That's why I have not announced them nor sent a pull request to Linus.

Anyway, thanks for the hints!

Thanks,
//richard
