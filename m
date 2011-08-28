Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1H1Xu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 19:50:28 -0400
Received: from ozlabs.org ([203.10.76.45]:33051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab1H1XuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 19:50:23 -0400
Date: Mon, 29 Aug 2011 09:50:21 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] All Arch: remove linkage for sys_nfsservctl system call
Message-ID: <20110828235021.GS19739@ozlabs.org>
Mail-Followup-To: "J. Bruce Fields" <bfields@fieldses.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ben Hutchings <ben@decadent.org.uk>, Neil Brown <neilb@suse.de>,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <1312810169.2591.1153.camel@deadeye>
 <20110808155538.GB904@fieldses.org>
 <20110808180658.GC29924@decadent.org.uk>
 <20110826220311.GA18140@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110826220311.GA18140@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 06:03:11PM -0400, J. Bruce Fields wrote:
> From: NeilBrown <neilb@suse.de>
> 
> The nfsservctl system call is now gone, so we should remove all
> linkage for it.

What about powerpc?

$ egrep -r nfsservctl arch/powerpc/
arch/powerpc/include/asm/systbl.h:COMPAT_SYS(nfsservctl)
arch/powerpc/include/asm/unistd.h:#define __NR_nfsservctl		168

Yours Tony
