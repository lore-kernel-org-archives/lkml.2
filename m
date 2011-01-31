Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1AaNsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:48:19 -0500
Received: from www.tglx.de ([62.245.132.106]:51813 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1AaNsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:48:18 -0500
Date: Mon, 31 Jan 2011 14:47:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
        Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        David Howells <dhowells@redhat.com>, yong.zhang0@gmail.com,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH v2 16/20] mn10300: switch do_timer() to xtimer_update()
In-Reply-To: <20110127150011.23248.62040.stgit@localhost>
Message-ID: <alpine.LFD.2.00.1101311446570.31804@localhost6.localdomain6>
References: <20110127145741.23248.68098.stgit@localhost> <20110127150011.23248.62040.stgit@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Torben Hohn wrote:

> xtimer_update() properly takes the xtime_lock.
> mn10300_last_tsc is only accessed from this function.

This patch can be dropped as that code is dead. I sent a cleanup patch
to the mn10300 folks.

Thanks,

	tglx
