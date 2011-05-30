Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab1E3Ws7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 18:48:59 -0400
Received: from mail.lang.hm ([64.81.33.126]:50989 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab1E3Ws6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 18:48:58 -0400
Date: Mon, 30 May 2011 15:48:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mariusz Kozlowski <mk@lab.zgora.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc1
In-Reply-To: <20110530200329.GA1833@mako-laptop>
Message-ID: <alpine.DEB.2.02.1105301545420.5766@asgard.lang.hm>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com> <BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com> <20110530200329.GA1833@mako-laptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, Mariusz Kozlowski wrote:

> On Sun, May 29, 2011 at 06:47:57PM -0700, Linus Torvalds wrote:
>
> [...]
>
>> However, I did *not* rename the git tree, because that would just be a
>> huge inconvenience to git users, so it's still in the same old place
>> and yes, that means that my git tree is still called "linux-2.6.git"
>> on kernel.org. But it has the v3.0-rc1 tag in it.
>>
>> I'll probably add a symlink or something, if people really hate being
>> reminded about our long history with the "2.6" numbering. But that
>> won't be until closer to the real release, methinks.
>
> You could consider freezing linux-2.6.git repository and creating new
> linux-3.git repository that would serve for a couple of years until
> linux-4.git. At the same time development history could be dropped between
> trees so that inital clones are lighter. Anyone interested in history
> can download idx/pack from linux-2.6.git repo and attach it using gratf
> point[1] anyway.
>
> Pros:
> - obvious naming scheme wrt repository contents
> - smaller initial clone
> - new clean tag namespace
>
> Cons:
> - broken bisection for some time
> - impaired log/blame/whatchanged and friends

in addition won't there be problems merging in work done on the old tree? 
(since there would be no common history)

everyone would need to re-clone their repository (and attaching history 
wouldn't help this)

there are probably others.

frankly I don't see any real benifits from the Pros you list. the initial 
clone is already rather small, it probably won't make that big a 
difference to throw away several years of history.

David Lang
