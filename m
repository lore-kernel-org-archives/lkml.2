Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1JAWdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:33:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43004 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1JAWdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:33:33 -0400
Message-ID: <4E879518.1050701@zytor.com>
Date: Sat, 01 Oct 2011 15:32:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Andy <akwatts@ymail.com>, Willy Tarreau <w@1wt.eu>,
        Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com> <20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus> <m2hb3stx6h.fsf@igel.home>
In-Reply-To: <m2hb3stx6h.fsf@igel.home>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2011 10:54 AM, Andreas Schwab wrote:
> Andy <akwatts@ymail.com> writes:
> 
>> I must be doing something wrong. I only have the 2.6 git repo (so my tags
>> don't drill down to 2.6.x.y just 2.6.x) but my experiement isn't giving
>> the results I expected.
>>
>> [Cloned repo]
>> $ git archive --format=tar --prefix linux-2.6.39/ v2.6.39 | md5sum
>> 482f8bd941def0548a95f34e2d290dfd  -
> 
> Try setting tar.umask to 022 (default is 002).
> 

One thing to be aware of is that tarballs produced with git before
version 1.5.0-rc1 (mid-January 2007) have owner/umask git/git 000 as
opposed to root/root 002 or 022.

	-hpa

