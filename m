Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab1E3SFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:05:33 -0400
Received: from mail.lang.hm ([64.81.33.126]:48876 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1E3SFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:05:32 -0400
Date: Mon, 30 May 2011 11:05:25 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Michal Marek <mmarek@suse.cz>
cc: Jon Masters <jcm@redhat.com>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] depmod: Handle X.Y kernel versions
In-Reply-To: <1306763923-11892-1-git-send-email-mmarek@suse.cz>
Message-ID: <alpine.DEB.2.02.1105301104310.5766@asgard.lang.hm>
References: <1306763923-11892-1-git-send-email-mmarek@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, Michal Marek wrote:

> Jon, could you please apply this patch and release a new
> module-init-tools?  Depmod otherwise fails when building a kernel with
> version 3.0 (without the third number).
>
> Linus, I'm affraid this ruins the plan for Linux 3.0. Except if you want
> to force users to upgrade module-init-tools, with the excuse that 3.0
> is a huge step forward and breakage has to be expected ;-).

it just means you need to do 3.0.0 (with -stable doing 3.0.1) instead of 
3.0 -> 3.0.1

David Lang
