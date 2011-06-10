Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1FJP0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab1FJP0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:26:33 -0400
Message-ID: <4DF23791.7060607@redhat.com>
Date: Fri, 10 Jun 2011 17:26:09 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild fixes for 3.0
References: <20110609214241.GA4849@sepie.suse.cz>	<BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>	<BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>	<BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>	<BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>	<BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>	<BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>	<BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com> <BANLkTikb0=CvTbN_njhq7JyJwOigEa0eLA@mail.gmail.com>
In-Reply-To: <BANLkTikb0=CvTbN_njhq7JyJwOigEa0eLA@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 05:06 PM, Andy Whitcroft wrote:
> As an experiment I have uploaded a 3.0 reporting kernel into Ubuntu
> Oneiric.  So far we have had issues with:
> 
>  - depmod -- (as above)
>  - procps (ps/top) -- reporting errors on startup
>  - glibc version checks are preventing upgrade of that package
> 
> I am sure there will be others

All tools based on libdevmapper (lvm, cryptsetup, kpartx, ...)
fails in initialization. (fixed already in devel tree)

mdadm is broken with 3.0 as well (it fails to auto assemble devices)
because of misparsing kernel version.

Fedora was quite proactive and added uts name patch "3.0-rc1",
so you can see what it caused... (unbootable system in short)

https://bugzilla.redhat.com/show_bug.cgi?id=710646

Milan
