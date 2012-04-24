Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2DXLI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:08:28 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:43800 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab2DXLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:08:26 -0400
From: Nix <nix@esperi.org.uk>
To: Chris Boot <bootc@bootc.net>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, carolyn.wyborny@intel.com
Subject: Re: [PATCH 1/2] e1000e: Disable ASPM L1 on 82574
References: <1335216578-21542-1-git-send-email-bootc@bootc.net>
	<1335216578-21542-2-git-send-email-bootc@bootc.net>
Emacs: a compelling argument for pencil and paper.
Date: Tue, 24 Apr 2012 12:08:09 +0100
In-Reply-To: <1335216578-21542-2-git-send-email-bootc@bootc.net> (Chris Boot's
	message of "Mon, 23 Apr 2012 22:29:37 +0100")
Message-ID: <87obqh75gm.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-dcc1.aftenposten.no-Metrics: spindle 1215; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Apr 2012, Chris Boot uttered the following:

> ASPM on the 82574 causes trouble. Currently the driver disables L0s for
> this NIC but only disables L1 if the MTU is >1500. This patch simply
> causes L1 to be disabled regardless of the MTU setting.

FWIW, that existing code doesn't actually work in any case. I've been
running with an MTU of 7200 on one such NIC for some time, and L0s and
L1 are definitely enabled, even though the driver says it's turning them
off.

I'll try your patch shortly, probably tomorrow. (Now I only have to
worry about the *other* bug that's been bruited about on this list --
the one where the card locks up if its peer shuts down. It's worrying
because one of my 82574Ls has a peer that's regularly suspended... I
guess I'll try and see if I can reproduce that lockup!)

-- 
NULL && (void)
