Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab2BXRSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:18:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35430 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2BXRSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:18:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.222.194 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 09:13:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224171344.GA9485@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
 <20120224165448.GA8751@kroah.com>
 <CAG4AFWY1a5SGA4AF9hpFrY6VE60OZUFtWmuVH92Ak_KZWs9Xtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG4AFWY1a5SGA4AF9hpFrY6VE60OZUFtWmuVH92Ak_KZWs9Xtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 12:06:54PM -0500, Jidong Xiao wrote:
> On Fri, Feb 24, 2012 at 11:54 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> As to "Linux isn't a microkernel", even though the debate between
> >> Linux and microkernel have never stopped,
> >
> > Um, who is having such a debate?  We aren't, so I don't think the debate
> > has ever started.
> >
> 
> Here is the classic debate between Andrew S. Tanenbaum and Linus Torvalds:
> http://en.wikipedia.org/wiki/Tanenbaum%E2%80%93Torvalds_debate

That was 20 years ago, to assume that anyone rational was still having
that debate today is insane.

