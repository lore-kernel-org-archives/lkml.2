Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab1EORSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:18:06 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:36081 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751212Ab1EORSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:18:05 -0400
Date: Sun, 15 May 2011 19:17:48 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: getter PTRACE_GETSIGINFO should not modify anything  [Re: [PATCH
 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110515171748.GA25216@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110515140232.GB31855@host1.jankratochvil.net>
 <20110515142827.GF23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515142827.GF23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

just a general point for all the mails:

On Sun, 15 May 2011 16:28:27 +0200, Tejun Heo wrote:
> Even for LD_PRELOAD, it can simply keep scheduling INTERRUPT
> until the application calls the wrapped GETSIGINFO when it detects the
> stopped state has changed.  It can be easily done from userland.

I thought the goal is to simplify the interface, not making it even more
complicated.


Thanks,
Jan
