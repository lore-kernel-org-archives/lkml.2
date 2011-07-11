Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab1GKOBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:01:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab1GKOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:01:29 -0400
Date: Mon, 11 Jul 2011 16:01:24 +0200
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: Re: [PATCH x86/urgent] x86: Disable AMD_NUMA for 32bit for now
Message-ID: <20110711140124.GD943@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110701162239.GX3386@htj.dyndns.org>
 <20110701162327.GY3386@htj.dyndns.org>
 <20110709083206.GB943@htj.dyndns.org>
 <4E181477.5090405@zytor.com>
 <20110711083432.GC943@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711083432.GC943@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just found out that the original two patch series was too strict for
cases where nid is recorded in page->flags (always for x86-64), so the
original two patch series would unnecessarily reject some NUMA
emulation configs, so the simple one for this release.  I'll post
updated patches for the next merge window later.

Thanks.

-- 
tejun
