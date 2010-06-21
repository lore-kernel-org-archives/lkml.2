Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab0FUU67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:58:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49264 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab0FUU65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:58:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: revert "Use block_til_ready helper"
Date: Mon, 21 Jun 2010 22:58:54 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc3-00068-g1931a4d-dirty; KDE/4.4.2; x86_64; ; )
Cc: Tony Luck <tony.luck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <20100621151309.334f6645@lxorguk.ukuu.org.uk> <201006212257.03436.arnd@arndb.de>
In-Reply-To: <201006212257.03436.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006212258.55209.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+5irj0SRLoswiLRvMwLEqlornHe8+n2AfB3c9
 ZUTXSlEOOZWpm720PGIYpS67Vb6TPJR8dZLs/6KN4tb5tILEOH
 R2kScB8dNDm5Qgw/B3b6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 June 2010 22:57:03 Arnd Bergmann wrote:
> I had to do it slightly different, see below. This patch also fixes
> the garbled output and lets me run cat> and getty on the onboard 16550a,
> but unlike the previous patch, I can't get a minicom connection between
> the two ports using hardware flow control now, so it seems that there
> is still another problem.

For clarification, the case that did not work was using minicom on both
ends. Disabling flow control works, enabling hardware flow control on
both ends fails but it worked fine with the patch I posted on Saturday.

	Arnd
