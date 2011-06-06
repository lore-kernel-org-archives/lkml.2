Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1FFHUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:20:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:47375 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab1FFHUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:20:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andrew Hamilton <Andrew.Hamilton@colorado.edu>
Subject: Re: 2.6.39 hangs on boot
Date: Mon, 6 Jun 2011 07:11:19 +0000 (UTC)
Message-ID: <loom.20110606T012417-146@post.gmane.org>
References: <201105282235.24530.M4rkusXXL@web.de> <201105301505.57407.M4rkusXXL@web.de> <20110530141841.GA20420@gere.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 71.56.238.24 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091205 Gentoo Firefox/3.5.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried the vanilla 2.6.39 today, but it doesnt even boot. The last 
> lines I see are:
> ...
> Switching to clocksource tsc

I have the same problem with hang on boot with 2.6.39.  It hangs at the same
point with the same message.

The problem seems to be fbcondecor.  Recompile your initrd without fbcondecor
and all works well, of course without a pretty background.

After boot-up splash_manager -c set can set up a pretty background, but
splash_manager -c switch produces a dysfunctional initrd.

Andrew

