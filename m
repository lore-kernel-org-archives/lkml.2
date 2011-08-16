Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1HPCVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:21:43 -0400
Received: from c60.cesmail.net ([216.154.195.49]:25814 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab1HPCVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:21:42 -0400
Message-ID: <20110815222141.jgw2q59rko0wssoc-cebfxv@webmail.spamcop.net>
Date: Mon, 15 Aug 2011 22:21:41 -0400
From: Pavel Roskin <proski@gnu.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suppressing a plus from setlocalversion
References: <20110815173706.12ccfdd4@mj>
	<alpine.DEB.2.00.1108151600400.22798@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1108151600400.22798@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Rientjes <rientjes@google.com>:

> On Mon, 15 Aug 2011, Pavel Roskin wrote:
>
>> Hello!
>>
>> There is one annoyance in the build system that I cannot work around.
>
> That's surprising since you actually state the workaround, i.e. using
> LOCALVERSION= with make, yourself.

OK, I don't consider that an acceptable solution, as it could  
interfere with other build systems.

However, as soon as I posted this message, I found a better solution,  
namely setting LOCALVERSION= in the environment (both for the normal  
user and for root).  This is less likely to have unexpected effects,  
since the environment variables don't override the variables  
explicitly set in makefiles.

> Yes, because the kernel you've produced is no longer 3.1.0-rc2, it is
> modified.  If you want to do something else locally, then you can always
> use LOCALVERSION=.
>
> The + was added to stop falsely identifying kernels as a specific version
> when they are modified by default.  Sorry if you forget to override it
> sometimes.

OK, I have an acceptable solution for my needs now, and if others need  
it, hopefully they would find this post.

-- 
Regards,
Pavel Roskin
