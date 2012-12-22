Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab2LVSau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 13:30:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50201 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2LVSar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 13:30:47 -0500
Date: Sat, 22 Dec 2012 19:30:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, netdev@vger.kernel.org
Subject: Re: Regression in 3.8-rc1:  "BUG: sleeping function called from
 invalid context"
Message-ID: <20121222183044.GA10263@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Pekka Enberg <penberg@kernel.org>, netdev@vger.kernel.org
References: <50D5E9D9.3070904@lwfinger.net>
 <20121222180247.GA10250@liondog.tnic>
 <1356199828.21834.8500.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1356199828.21834.8500.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 10:10:28AM -0800, Eric Dumazet wrote:
> RTNL is a mutex, its perfectly valid to use GFP_KERNEL while holding a
> mutex.

Right, sorry. The check fires because we have preemption disabled.

> As replied before your mail, fix for the problem is already in David
> tree.

Yep, saw that after hitting send.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
