Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1D3So1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 14:44:27 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:55021 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1D3SoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 14:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QsGlFvbYvz1lB/ni/D9wKW8qghoTm352mLrsvwmCm++Ppbg4lsreuylgwcipg3RHTt
         //RbwYE7z15PZnQyrANjnWjnpwOtZ5rCRX3IU/rO8FiSKEC1X6vxLtcm3kmHWE+Q4wSm
         HZls4TinG6QLwRmEle+TV78/fF2Jdv9gpz2jw=
Message-ID: <4DBC587B.30803@gmail.com>
Date: Sat, 30 Apr 2011 11:44:11 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com, tj@kernel.org
Subject: Re: 2.6.39-rc5-git2 boot crashs
References: <web-515866242@zbackend1.aha.ru> <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com> <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com> <20110430025545.GI9487@ZenIV.linux.org.uk> <20110430030243.GJ9487@ZenIV.linux.org.uk> <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com> <web-515898476@zbackend1.aha.ru> <BANLkTi=ujRJYG80F=HKqgz2nPeE5Gro+JA@mail.gmail.com> <web-515901951@zbackend1.aha.ru> <BANLkTi=o7NynvukkzE5ZhRHPu43=OV0_Ow@mail.gmail.com> <web-515904487@zbackend1.aha.ru> <BANLkTimDHTB+NF8EzjvjBvu0e+MHt8tP1Q@mail.gmail.com> <web-515907842@zbackend1.aha.ru> <BANLkTimu=XAj5JDewT9OGTCNHZBf2Oa5+Q@mail.gmail.com> <web-516065216@zbackend1.aha.ru>
In-Reply-To: <web-516065216@zbackend1.aha.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 11:31 AM, werner wrote:
> Since years it's all the time that I compile the kernel with everything
> enabled, because these kernel builds are for a distro, and should work
> on any computer. Normally, things going stable at -rc3 or -rc4 , often
> already at -rc2.
>
> Beside of with my computer, essentially the same problems also happens
> with a laptop of a friend.
>
> Also, a big problem are the (after-boot-) crashs if zipping / unzipping
> big files. Packages I can build only with 2.6.38.4, not with 2.6.39-rcX
>
> Below is the diff between the config of 2.6.38.4 and 2.6 39-rc5-git3 .
> You could inspect them what potentially could explain the reported
> problems. But I think at least the problems which happens on my
> computer, and on that of the friend, are regressions, because none of
> the new staging drivers we use.
>
> wl
>

make localmodconfig for a small .config and also use some kind of early 
debugger(under kernel hacking) to grab the crash info so linus can see 
the problem.

Justin P. Mattock


