Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2GMVGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:06:14 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:43047 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2GMVGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:06:13 -0400
Message-ID: <50008DBD.2030800@hp.com>
Date: Fri, 13 Jul 2012 15:06:05 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
In-Reply-To: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 02:37 PM, Linus Torvalds wrote:

>
> Would something like this make sense to people? I really think that
> "How do I generate a kernel config file" is one of those things that
> keeps normal people from compiling their own kernel. And we *want*
> people to compile their own kernel so that they can help with things
> like bisecting etc. The more, the merrier.
>
This is a great idea. 7-8 years ago I used to be able to create a
minimally configured kernel from upstream and run my Debian/Ubuntu/...
install with it. It got much harder in a hurry and now it takes too much
work to figure out how to configure upstream kernel to make it work with
distro. It is a 3-5 hour compile to start with distro config file and that
is just too painful. I will help with testing configs or helping sort
through the config options.

-- 
Khalid Aziz
khalid.aziz@hp.com

