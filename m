Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1JJRAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:00:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49877 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1JJRAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:00:33 -0400
Date: Mon, 10 Oct 2011 10:00:27 -0700
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, bp@amd64.org, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and
 suspend/hibernate
Message-ID: <20111010170027.GD8100@google.com>
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
 <20111010123242.15067.48238.stgit@srivatsabhat.in.ibm.com>
 <4E92E8E0.4090004@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E92E8E0.4090004@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 10, 2011 at 06:15:20PM +0530, Srivatsa S. Bhat wrote:
> Would it be better to hook into the suspend/hibernate notifiers and
> use them to exclude cpu hotplug from suspend/hibernate, instead of
> trying to take pm_mutex lock like this?

If this change is determined to be necessary, I think it would be
better to make it explicit.  Exclusion through callbacks often makes
the locking just more obscure.

Thanks.

-- 
tejun
