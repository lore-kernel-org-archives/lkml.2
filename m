Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0CQU5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 16:57:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59375 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0CQU5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:57:16 -0400
Message-ID: <4BA1412C.6070008@zytor.com>
Date: Wed, 17 Mar 2010 13:53:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ulrich Drepper <drepper@redhat.com>, munroesj@us.ibm.com,
       David Miller <davem@davemloft.net>, ralf@linux-mips.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, torvalds@linux-foundation.org
Subject: Re: 64-syscall args on 32-bit vs syscall()
References: <20100315134449.GB1653@linux-mips.org>	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>	 <20100315.120004.209998642.davem@davemloft.net>	 <4B9E8D67.8040209@zytor.com>  <1268685311.2335.38.camel@pasglop>	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>	 <1268785874.2335.137.camel@pasglop>  <4BA06E1B.2040706@redhat.com>	 <1268816179.2335.187.camel@pasglop>  <4BA11FD2.2090104@zytor.com> <1268858134.2335.198.camel@pasglop>
In-Reply-To: <1268858134.2335.198.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 01:35 PM, Benjamin Herrenschmidt wrote:
> On Wed, 2010-03-17 at 11:30 -0700, H. Peter Anvin wrote:
>> Again, this is *exactly* symbol versioning done by hand... we have
>> proper symbol versioning, let's use it.
>
> Yeah, whatever, I don't mind what technique you use for the versionning,
> ultimately, if the approach works, we can look at those details :-) We
> -do- need the macro to strip the dummy argument though, unless we use
> a slightly different technique which is to make the __sysno argument
> itself 64-bit, which works as well I believe.
>

It seems cleaner to do it that way (with a 64-bit sysno arg.)

	-hpa
