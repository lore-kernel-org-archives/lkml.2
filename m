Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab1G1Rco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:32:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41335 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1G1Rcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:32:43 -0400
Date: Thu, 28 Jul 2011 19:32:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, gregkh@suse.de,
        herton.krzesinski@canonical.com, gengor@gentoo.org,
        donald.h.fry@intel.com, wey-yi.w.guy@intel.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [64/99] Revert "iwlagn: Support new 5000 microcode."
Message-ID: <20110728173241.GJ8006@one.firstfloor.org>
References: <20110727247.325703029@firstfloor.org> <20110727214903.75C262403FF@tassilo.jf.intel.com> <20110728082425.GA2207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728082425.GA2207@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit dd7a2509b3a79b290730a9c6a784bf03fedabb9a
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Apr 28 23:33:10 2010 -0700
> 
>     iwlagn: implement loading a new firmware file type
> 
> > This was reported by Gentoo, Arch, and Canonical developers as causing
> > problems for their users:
> > 	https://bugs.archlinux.org/task/24302
> This is a bug about 2.6.32.
> 
> > 	http://bugs.gentoo.org/show_bug.cgi?id=359445
> This looks like problem when only 8.83.5 (v5) firmware is available
> on the system, but kernel is old and support only v2 version. This
> should be solved by providing both old 8.24.2 (v2) and new 8.83.5 (v5)
> firmware blobs in one package.
> 
> > 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/796336
> Also 2.6.32 case.

I took them from .32. Should I drop them?

> 
> There could be reasons for this change, but I do not see them here.

Can you please clearly indicate which patches I should drop and which keep?

Thanks,
-Andi
