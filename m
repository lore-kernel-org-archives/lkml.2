Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0EaSLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:11:53 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:41568 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0EaSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:11:52 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34 nfs fsync() deadlock
References: <87r5ksjfql.fsf@spindle.srvr.nix>
	<1275320467.5038.9.camel@heimdal.trondhjem.org>
From: Nix <nix@esperi.org.uk>
Emacs: no job too big... no job.
Date: Mon, 31 May 2010 19:11:49 +0100
In-Reply-To: <1275320467.5038.9.camel@heimdal.trondhjem.org> (Trond Myklebust's message of "Mon, 31 May 2010 11:41:07 -0400")
Message-ID: <87zkzghrfe.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2010, Trond Myklebust said:
> Can you see if the following 2 attached patches (already sent to
> stable@kernel.org) suffice to fix the hang?

It's hard to be absolutely certain (it only fails about a tenth of the
time with this testcase), but it seems to fix it (I've run a hundred or
so tests and it's still going).
