Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1HRLJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:09:24 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47866 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab1HRLJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:09:22 -0400
Subject: Re: [PATCH 00/41] signal: Use set_current_blocked()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1313619446.2311.52.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <20110811160358.GA7989@redhat.com>
	 <1313523659.3436.184.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110817170152.GA22499@redhat.com>
	 <1313619446.2311.52.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 12:09:15 +0100
Message-ID: <1313665755.2311.57.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 23:17 +0100, Matt Fleming wrote:
> 
> This does look like a decent clean up, especially because so many
> architectures got this sequence wrong in the past. But yeah, it will
> require me to rewrite half my series ;-)
> 
> Is it worth rewriting the series? Dunno. I'm not convinced that the
> wrapper buys us enough for that, plus it'd increase the number of
> patches.
> 
> Maybe it'd be better to do it as a separate set of patches?

OK so, I went ahead and rewrote the series using your clean up. It's in
the 'oleg/set-current-blocked-v2' branch at, 

git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux-2.6.git

Would you mind taking a quick look and see which series you prefer? I'll
wait for your reply before I resend any patches.

-- 
Matt Fleming, Intel Open Source Technology Center

