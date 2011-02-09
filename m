Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab1BIWca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:32:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43472 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1BIWc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:32:29 -0500
Message-ID: <4D5315FB.8020004@zytor.com>
Date: Wed, 09 Feb 2011 14:32:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jidong Xiao <jidong.xiao@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Can anyone explain "movl %eax %eax"?
References: <AANLkTikA3MT=eeMKg58HyYZRswUR+PMhYW978HEc0sst@mail.gmail.com>
In-Reply-To: <AANLkTikA3MT=eeMKg58HyYZRswUR+PMhYW978HEc0sst@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 02:24 PM, Jidong Xiao wrote:
> Hi,
> 
> In the kernel source, I see in a couple of places, there is "movl %eax
> %eax". Is this used for alignment purpose?
> 
> For example, in the following piece of code we can see "movl %eax,%eax".
> 

In x86-64, a dword (long) operation clears the upper 32 bits of the
target register, so "movl %eax,%eax" clears the upper 32 bits of %rax.

	-hpa

