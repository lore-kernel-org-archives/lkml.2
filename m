Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1F2KvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:51:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab1F2KvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:51:06 -0400
Date: Wed, 29 Jun 2011 12:51:01 +0200
From: Tejun Heo <tj@kernel.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110629105101.GK3386@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629094451.GJ3386@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:44:51AM +0200, Tejun Heo wrote:
> Hmmm... I can't see how it would have worked before.  amdtopology used
> ulong for @end and would simply have been zero.  Maybe NUMA config
> failed and it booted as flatmem instead?  Can you please post boot log
> before the patch?

Ooh, please forget about this one.  I got confused and thought that
amdtopology was for 32bit only and then converted to apply to both 32
and 64.  It was the other way around, so the machine didn't use to get
NUMA configuration at all.

-- 
tejun
