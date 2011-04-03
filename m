Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1DCKWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab1DCKWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:22:44 -0400
Message-ID: <4D984A58.5090902@redhat.com>
Date: Sun, 03 Apr 2011 13:22:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com, mingo@elte.hu
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com>	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>	<4D9847BC.9060906@redhat.com> <BANLkTik5-ohx47AyLz_mJkCqNtO4uKVBew@mail.gmail.com>
In-Reply-To: <BANLkTik5-ohx47AyLz_mJkCqNtO4uKVBew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2011 01:17 PM, Pekka Enberg wrote:
> Hi Avi,
>
> On Sun, Apr 3, 2011 at 1:11 PM, Avi Kivity<avi@redhat.com>  wrote:
> >>  SMP, networking, and simpler guest to host communication from shell
> >>  are most interesting missing features for me.
> >
> >  If it is to be more than a toy, then Windows (really generic guest) support,
> >  manageability, live migration, hotplug, etc. are all crucial.
>
> It's definitely not a toy, it's my main virtualization tool of choice
> for kernel development! ;-)
>
> The features you mention are crucial for servers but not for desktop.
> I personally don't have much need for managing and live-migrating
> Windows guests but if someone is interested in working on that, we're
> happy to take patches!

Well, I'd say you do need generic guest support for desktop (but not the 
other stuff I mentioned).  Are you planning to add a real GUI?

-- 
error compiling committee.c: too many arguments to function

