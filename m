Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0IHVZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:25:06 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:41746 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0IHVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:25:03 -0400
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (ACPI idle?)
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette>
From: Nix <nix@esperi.org.uk>
Emacs: if it payed rent for disk space, you'd be rich.
Date: Wed, 08 Sep 2010 22:24:59 +0100
In-Reply-To: <20100906053255.GA23340@brouette> (Damien Wyart's message of "Mon, 6 Sep 2010 07:32:55 +0200")
Message-ID: <87iq2gyllg.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Sep 2010, Damien Wyart uttered the following:
> So if you can reproduce it quite easily, I guess bisection (even

ha ha ha. I thought I could, but it's intermittent enough to make
bisection pretty much impossible, and when I gave up and rebooted back
into 2.6.35.4 the bug went away entirely.

I don't think bisection will work with something this intermittent :/
