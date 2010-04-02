Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0DBWEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 18:04:16 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:56237 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0DBWEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 18:04:07 -0400
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com
Subject: Re: unhelpful and somewhat scary r8169 boot message in 2.6.33.2 regarding a security fix
References: <87iq89q3v2.fsf@spindle.srvr.nix>
	<20100402.143627.11964909.davem@davemloft.net>
From: Nix <nix@esperi.org.uk>
Emacs: it's all fun and games, until somebody tries to edit a file.
Date: Fri, 02 Apr 2010 23:03:44 +0100
In-Reply-To: <20100402.143627.11964909.davem@davemloft.net> (David Miller's message of "Fri, 02 Apr 2010 14:36:27 -0700 (PDT)")
Message-ID: <87aatl7br3.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-x.dcc-servers-Metrics: spindle 104; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 Apr 2010, David Miller verbalised:

>> but it does not explain *why* changing the MTU is suddenly so bad,
>> when it's worked forever before now without flaw, with no sign of
>> any sort of corruption. Why should we be confined to non-jumbo
>> frames? What are the effects if we do change MTU?
>
> Have a look at CVE-2009-4537
>
> It's a remotely exploitable memory corruptor and potential
> root hole.

That's what I thought, *if* the attackers can inject crafted Ethernet
frames onto your local network. (i.e., they need a crafted Ethernet
frame, not just crafted packet contents.)
