Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0LHW1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:27:43 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60281 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0LHW1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:27:42 -0500
Date: Wed, 8 Dec 2010 14:27:13 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, penberg@kernel.org,
        alan@lxorguk.ukuu.org.uk, tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/cpu] x86, cpu: Clear XD_DISABLED flag on Intel to
 regain NX
Message-ID: <20101208222713.GP5750@outflux.net>
References: <1289414154-7829-3-git-send-email-kees.cook@canonical.com>
 <tip-ae84739c27b6b3725993202fe02ff35ab86468e1@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-ae84739c27b6b3725993202fe02ff35ab86468e1@git.kernel.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 02:49:04AM +0000, tip-bot for Kees Cook wrote:
> Commit-ID:  ae84739c27b6b3725993202fe02ff35ab86468e1
> Gitweb:     http://git.kernel.org/tip/ae84739c27b6b3725993202fe02ff35ab86468e1
> Author:     Kees Cook <kees.cook@canonical.com>
> AuthorDate: Wed, 10 Nov 2010 10:35:52 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 10 Nov 2010 15:42:54 -0800
> 
> x86, cpu: Clear XD_DISABLED flag on Intel to regain NX

Just some quick positive feedback on this patch series: I've had at least
one confirmed report of a user with an Asus system that had NX disabled
(in the BIOS which offered no toggle to switch it on) is able to use
the NX bit on their CPU finally. Additionally, no regressions have been
identified either, and there has been a fair number of people running
with the patch for a few weeks now in Ubuntu's development kernel.

-Kees

-- 
Kees Cook
Ubuntu Security Team
