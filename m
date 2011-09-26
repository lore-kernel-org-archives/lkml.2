Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1IZSck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:32:40 -0400
Received: from claw.goop.org ([74.207.240.146]:33003 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab1IZScj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:32:39 -0400
Message-ID: <4E80C545.1070404@goop.org>
Date: Mon, 26 Sep 2011 11:32:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Could you reinstate ticketlock cleanups in tip.git
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Could you reinstate the ticketlock cleanup series in tip.git (I think it
was in x86/spinlocks) from
    git://github.com/jsgf/linux-xen.git upstream/ticketlock-cleanup

This branch is the final result of all the discussions and revisions and
is ready for the next merge window.  It's the one that's been in
linux-next for a couple of weeks (at least), and won't cause any
conflicts there.

Or if you prefer I can submit it myself for next merge window.

Thanks,
    J
