Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0ITUeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:34:19 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35629 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0ITUeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:34:18 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Venkatesh Pallipadi" <venki@google.com>
Subject: Re: [Bug #18272] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (ACPI idle?)
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
	<aRnAGz9xZ8K.A.lAF.897lMB@chimera>
From: Nix <nix@esperi.org.uk>
Emacs: is that a Lisp interpreter in your editor, or are you just happy to see me?
Date: Mon, 20 Sep 2010 21:33:18 +0100
In-Reply-To: <aRnAGz9xZ8K.A.lAF.897lMB@chimera> (Rafael J. Wysocki's message of "Mon, 20 Sep 2010 21:57:22 +0200 (CEST)")
Message-ID: <87pqw8f94h.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=8 Fuz1=8 Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Sep 2010, Rafael J. Wysocki said:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).

Resolved by 54ff7e595d763d894104d421b103a89f7becf47c in master,
which is landing in 2.6.35.5 imminently.
