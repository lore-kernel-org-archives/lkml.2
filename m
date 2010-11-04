Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0KDCk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 22:40:58 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49037 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0KDCk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 22:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=wRhtu/idS7a/G4yn30+41tllipE5iCsFZBfLxVr1V94bWgQZdv5axc0qMuK/6740pA
         rx/9mPxdoXaEALLUvvpbL2D1vBZQpJzbn3n+wAc8ZYvuW95vuh9v3Wc/vW17wSigTLjx
         E8BNnb+udtOaJAobTatbydgfs/8QJjRch9LOA=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Dave Jones <davej@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
In-Reply-To: <20101103143358.GA19777@redhat.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com> <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com> <87oca7evbo.fsf@gmail.com> <20101102140119.GA8294@localhost> <20101103143358.GA19777@redhat.com>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Nov 2010 22:40:52 -0400
Message-ID: <87hbfxbykr.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010 10:33:59 -0400, Dave Jones <davej@redhat.com> wrote:
> Not sure why I was cc'd on this, but at least for Fedora, we still take
> the 'one kernel to rule them all' approach for every spin (and will likely
> continue to do so to maximise coverage testing) so a config option for us
> for things like this is moot.
> 
Just didn't want to miss anyone important. Sorry for the noise.

> Whenever I've tried to push changes to our defaults through to our
> default /etc/sysctl.conf, it's been met with resistance due to beliefs
> that a) the file is there for _users_ to override decisions
> the distro made at build time and b) if this is the right default,
> why isn't the kernel setting it?
>
This seems to be the consensus within the Ubuntu community as well. I
don't have any strong opinion either way but I will admit that setting
it in userspace does make the packaging issue messy.

- Ben
