Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1BNSJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:09:47 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35504 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1BNSJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:09:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=Ah59YeGzZ9nfdU6IdirX72YAeXiMRt8QMHRXeIRBiHvCfAGLX5ovjs3ho6CUH4iaGR
         cnT33EmxOEMjhRehEPp3NJoR3qjVlOrIj6HpoPP3miBgzrfYMrpigZRdJ1x4NyR5Vey5
         FSJ5TLdjC5rZPUOxH8evFgp71xr7Gj6S2X+fQ=
From: Ben Gamari <bgamari.foss@gmail.com>
To: chris2553@googlemail.com, LKML <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: System lockup with 2.6.38-rc4+
In-Reply-To: <201102141731.29331.chris2553@googlemail.com>
References: <201102141731.29331.chris2553@googlemail.com>
User-Agent: Notmuch/0.5-64-gdd23272 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Mon, 14 Feb 2011 13:09:03 -0500
Message-ID: <87fwrqxzcw.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 17:31:29 +0000, Chris Clayton <chris2553@googlemail.com> wrote:
> Hi,
> 
> I'm not subscribed, so please cc me on any reply.
> 
> I've just had a complete system lock up with a kernel that I pulled, built and 
> installed yesterday morning. IT was locked hard and I had to power off and on 
> to get it back.
>
It looks like the GPU barfed. If you SSH'd in to the machine you'd find
that everything but the display and resources held by the hung X server
would be fine. Were you doing anything particular in your X session when
this happened? There's a good chance this isn't actually a kernel bug
but instead is a DRI client doing something dumb.

Cheers, 

- Ben

P.S. The bzipped kernel image generally won't help in diagnosing the
problem. The most important thing to include in a bug report is the
kernel version and the dmesg output from the failure if available. Folks
will ask later if more is necessary.
