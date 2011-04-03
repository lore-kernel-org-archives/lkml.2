Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1DCKLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:11:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab1DCKLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:11:43 -0400
Message-ID: <4D9847BC.9060906@redhat.com>
Date: Sun, 03 Apr 2011 13:11:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com, mingo@elte.hu
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com> <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
In-Reply-To: <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2011 12:59 PM, Pekka Enberg wrote:
> Hi Avi,
>
> On Sun, Apr 3, 2011 at 11:23 AM, Avi Kivity<avi@redhat.com>  wrote:
> >>  Note that this is a development prototype for the time being: there's no
> >>  networking support and no graphics support, amongst other missing
> >>  essentials.
> >
> >  Mind posting a roadmap?  I would put smp support near the top.  This sort of
> >  thing has to be designed in, otherwise you wind up with a big lock like
> >  qemu.
>
> What are the pain points with qemu at the moment?

It's an ugly gooball.

> SMP, networking, and simpler guest to host communication from shell
> are most interesting missing features for me.

If it is to be more than a toy, then Windows (really generic guest) 
support, manageability, live migration, hotplug, etc. are all crucial.

> I'd also love to have
> GPU support for X and friends.

Should be easy to get by integrating spice (but that gives you a 
remote-optimized display, not local).

-- 
error compiling committee.c: too many arguments to function

