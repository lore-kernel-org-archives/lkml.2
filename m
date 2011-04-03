Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab1DCIY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 04:24:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1DCIYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 04:24:55 -0400
Message-ID: <4D982EB8.7080001@redhat.com>
Date: Sun, 03 Apr 2011 11:24:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar> <4D978930.1000909@codemonkey.ws> <20110403062117.GA27121@elte.hu>
In-Reply-To: <20110403062117.GA27121@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2011 09:21 AM, Ingo Molnar wrote:
> * Anthony Liguori<anthony@codemonkey.ws>  wrote:
>
> >  On 03/31/2011 12:30 PM, Pekka Enberg wrote:
> >  >  Hi all,
> >  >
> >  >  We’re proud to announce the native Linux KVM tool!
> >
> >  Neat!
> >
> >  As something of a lesson of history, I'd suggest picking a more unique name
> >  while it's still a prototype :-)
>
> I disagree, i find it pretty handy and intuitive to run 'kvm ./disk.img' to
> boot KVM and this particular tool name has not been taken yet either.

Some distributions install qemu-kvm as /usr/bin/kvm.

> perf uses a similar concept: the kernel subsystem is generally called 'perf',
> and the (Linux specific) user-space tool is called 'perf' as well. It makes
> quite a bit of sense.

Well, this is bound to cause confusion as the tool is yet quite immature.

-- 
error compiling committee.c: too many arguments to function

