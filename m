Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0JDR5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:57:50 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47714 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756360Ab0JDR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:57:49 -0400
Date: Mon, 4 Oct 2010 19:57:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: vaibhav agarwal <vaibhav_agrwal@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel panic in 2.6.36-rc4 after suspend/resume
Message-ID: <20101004175743.GI1518@ucw.cz>
References: <710896.84473.qm@web137411.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <710896.84473.qm@web137411.mail.in.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Pid: 0, comm: swapper Not tainted 2.6.36-rc4-custom #18 Aspire 4736Z    /Aspire 
> 4736Z
> EIP: 0060:[<f83de653>] Eflags: 00010206 CPU: 0
> EIP is ay sta_addba_resp_timer_expired+0x17/0x28 [max80211]

Try uncloading mac80211 before suspend?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
