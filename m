Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0HLT5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:57:50 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:43372 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751914Ab0HLT5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:57:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=F0iTp/7A5zn4OYbJ5gK9Pi08vuhnnDdwC0+lOMuIW9BwKECvEZsoODzW8OelKMVWJ6lPtoHXc387kz9VTjWNEf5dIC/29w9lED4kioWGgIU6eTYvN6QUDqkazFobJfSs;
Date: Thu, 12 Aug 2010 12:57:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Brian Swetland <swetland@google.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100812125712.48b7fc26@virtuousgeek.org>
In-Reply-To: <AANLkTimjfU2zu4reEVdOwWwtFHPQ33_Gna6xS2XHRG-h@mail.gmail.com>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	<AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	<20100812125248.GA2763@thunk.org>
	<AANLkTin4=qpDWEKLwes_af6mSCW+ED7v-fWzD34JywU1@mail.gmail.com>
	<20100812182128.GC2763@thunk.org>
	<AANLkTinZ_gViUjVmEbkmour3BC=PcchJDARs4GaCuQwO@mail.gmail.com>
	<AANLkTimjfU2zu4reEVdOwWwtFHPQ33_Gna6xS2XHRG-h@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010 12:19:34 -0700
Brian Swetland <swetland@google.com> wrote:
> Question though -- has every feature ever added to the kernel been a
> feature that there's pre-existing usage of?  Seems like a chicken and
> egg problem.  Also, some people seem to think there's value in being
> able to build kernels "out of the box" that work with the Android
> userspace -- given that there are a few devices out there that have
> that userspace on 'em.

We generally try to merge new features like this along with code that
uses said feature, but there are always exceptions.  We've merged code
one release or more before the new code gets used for example, which is
fine IMO.  What we don't want to see is some new drop of code added and
abandoned, but you already knew that.

At any rate, if Felipe is the only one arguing against including
suspend blockers in the kernel, you're probably in good shape.  Based
on my (rather cursory I admit) evaluation of this thread, it seems like
reasonable people agree that there's a place for a suspend blocker like
API in the kernel, and that dynamic power management is also highly
desirable.  So where's the git pull request already? :)

-- 
Jesse Barnes, Intel Open Source Technology Center
