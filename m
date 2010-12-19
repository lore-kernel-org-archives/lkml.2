Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab0LSN4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 08:56:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0LSN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 08:56:23 -0500
Date: Sun, 19 Dec 2010 14:56:21 +0100
From: Heinz Diehl <htd@fritha.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Heinz Diehl <htd@fancy-poultry.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #24892] Wireless warning, system locks up
Message-ID: <20101219135621.GB13734@fritha.org>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
 <6Ue85L6pKCJ.A._TD.0dfDNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6Ue85L6pKCJ.A._TD.0dfDNB@chimera>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:HAw7AvhknZ1T2JhQE4bCxb6ZZdMA5bZgTXOrcJM6TiS
 tzWW/qeRCuKCJhcLHsbbKPA97nPXrQDArIyP+VW5ehZ8wcY+kb
 52rhKy2P7PnVvd2sO8J4vYwK3Wcu+r9plZQ6rMmGrhzi44EitJ
 sYpPFE8bxHkfYRe2N7cljLFgCv9wl8hQq+YoqTTiVQNMuSi8cu
 Yp/+SkYIyOb1wehnq6dmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.12.2010, Rafael J. Wysocki wrote: 

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24892
> Subject		: Wireless warning, system locks up
> Submitter	: Heinz Diehl <htd@fancy-poultry.org>
> Date		: 2010-12-14 15:16 (6 days old)
> Handled-By	: John W. Linville <linville@tuxdriver.com>

This patch from John Linville fixes it:
https://bugzilla.kernel.org/attachment.cgi?id=40112


