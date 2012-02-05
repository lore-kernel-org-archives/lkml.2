Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2BEKo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 05:44:28 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51243 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152Ab2BEKo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 05:44:27 -0500
Date: Sun, 5 Feb 2012 11:44:18 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Chinmay V S <chinmay.v.s@pathpartnertech.com>
Cc: linux-kernel@vger.kernel.org, cvs268@gmail.com, tglx@linutronix.de,
        sebastian@breakpoint.cc, arjan@linux.intel.com,
        jeff.chua.linux@gmail.com
Subject: Re: [PATCH] [timer] Optimise apply_slack() for size and speed.
Message-ID: <20120205104417.GA6103@kibibi>
References: <arjan@linux.intel.com>
 <1328284850-27743-1-git-send-email-chinmay.v.s@pathpartnertech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1328284850-27743-1-git-send-email-chinmay.v.s@pathpartnertech.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chinmay V S | 2012-02-03 21:30:50 [+0530]:

>Updated the patch for improved readability.
Arjan's point was that this is not critical for performance and as such
it does not need an improvement.

>How about the following patch?
I guess this will be left as is.

Sebastian
