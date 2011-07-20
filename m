Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1GTJFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 05:05:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:45740 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1GTJFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 05:05:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: David Kastrup <dak@gnu.org>
Subject: Re: [ANNOUNCE] 3.0-rc7-rt0
Date: Wed, 20 Jul 2011 11:02:40 +0200
Organization: Organization?!?
Message-ID: <87hb6hpbnz.fsf@fencepost.gnu.org>
References: <alpine.LFD.2.02.1107200153070.2702@ionos>
Mime-Version: 1.0
Content-Type: text/plain
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p508e97c0.dip.t-dialin.net
X-Face: 2FEFf>]>q>2iw=B6,xrUubRI>pR&Ml9=ao@P@i)L:\urd*t9M~y1^:+Y]'C0~{mAl`oQuAl
 \!3KEIp?*w`|bL5qr,H)LFO6Q=qx~iH4DN;i";/yuIsqbLLCh/!U#X[S~(5eZ41to5f%E@'ELIi$t^
 Vc\LWP@J5p^rst0+('>Er0=^1{]M9!p?&:\z]|;&=NP3AhB!B_bi^]Pfkw
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
Cancel-Lock: sha1:Y6jwRKb26X3IdSOTkYltlchw6hY=
Cc: linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> The overall patch size has shrunk significantly and the readability
> (except for the missing changelogs in various patches) is at an
> acceptable level.

Well, thanks for all the work.  I am actually already using per-irq
threads and priorities on a 3.0-rc kernel (there is some boot option to
enable them), and that helps for audio operation.

It would be really great if realtime can move upstream completely
eventually, and it looks like the current approach is a better match to
the existing kernel, partly due to upstream improvements, partly through
rewritten realtime code.

The ongoing work seems very promising and seems to involve fewer
compromises, boding well not just for the chances of getting merged
upstream, but also of minimizing regressions compared to the
non-realtime kernel.

Thanks!

-- 
David Kastrup

