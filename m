Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab0IWSVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:21:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41351 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0IWSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=VRJkK7wow+8yc+Z8iPdpQcLTmwMxvlvOvk2KPALrjgjk70gRm0vUnRPZU6v+imEIL5
         ouQFpXYy9UzbPVYDiVUTveITgzkn2XDgugixSGkXJCkJbh8LWeCWWztNoSw8z9cobu4E
         TIwW8QKcH2JTMkMuZFpdlddrgOl9rkU7slLFU=
Date: Thu, 23 Sep 2010 20:21:12 +0200
From: Paolo Ornati <ornati@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
        Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
        intel-gfx@lists.freedesktop.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Interrupt latency on some 945GM platforms
Message-ID: <20100923202112.7efa65a7@gmail.com>
In-Reply-To: <20100921155653.440afea4@jbarnes-desktop>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009171002.09187.simon.farnsworth@onelan.co.uk>
	<4b4d1e0a-b1ad-40f1-a829-6d4726d2b2d3@email.android.com>
	<201009171550.48480.anarsoul@gmail.com>
	<20100921202607.2b46ffca@gmail.com>
	<20100921155653.440afea4@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 15:56:53 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Can you guys try something like this?  My theory is that 945GM has some
> power management behavior we're failing to configure correctly.  If
> disabling it works, then it's likely related.

"processor.max_cstate=1" solves the problem too, tomorrow (it takes time
to be sure the problem is gone) I'll run with "processor.max_cstate=2"
and then I'll try with the patch alone.

-- 
	Paolo Ornati
	Linux 2.6.35.4 on x86_64
