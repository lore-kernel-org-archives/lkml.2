Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab0DBGgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:36:52 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43608 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758431Ab0DBGgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:36:46 -0400
Date: Fri, 2 Apr 2010 08:36:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] what the patches do Re: [RFC 10/15] PM / Hibernate:
	user, implement user_ops reader
Message-ID: <20100402063644.GA14941@atrey.karlin.mff.cuni.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <201003252114.36605.rjw@sisk.pl> <4BABC5B6.2070301@crca.org.au> <201003252129.10224.rjw@sisk.pl> <20100325212656.GD22902@elf.ucw.cz> <4BABDA59.8070107@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BABDA59.8070107@crca.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>>> So what's your long term plan then?
>>>
>>> First, improve the in-kernel thing, second, switch people to it, _then_ remove
>>> the s2disk interface (after we're reasonably sure it's not used by any major
>>> distro) and _finally_ simplify things after it's been removed.
>>
>> I'd really prefer to keep s2disk interface. It allows advanced stuff
>> like internet suspend resume (yep someone is doing it), crazy stuff
>> like multiple resumes from same image for fast booting (yep, some
>> embedded people are doing that) and might-be-useful stuff like
>> s2both...
>
> Neither of those are impossible with in-kernel code, so I'd argue that  
> there's no need to keep the s2disk interface long-term. Userspace  

I disagree.

> helpers might be necessary for the first one (to manage the network  
> interface), but I already have multiple-resumes-from-the-same-image  
> support in TuxOnice (and more 'crazy stuff' like support for resuming a  
> different image after writing one - that can be used to switch to an  
> initramfs containing the binaries needed to power down a UPS).

The fact that it can be done in kernel -- anything can -- but whether
it should. I'd very much like to keep the 'crazy stuff' in userspace.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
