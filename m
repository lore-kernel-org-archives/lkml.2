Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162097Ab2CSQUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:20:03 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:55939 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031893Ab2CSQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:19:55 -0400
From: Nix <nix@esperi.org.uk>
To: "Wyborny\, Carolyn" <carolyn.wyborny@intel.com>
Cc: Chris Boot <bootc@bootc.net>,
        "e1000-devel\@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] e1000e interface hang on 82574L
References: <4EFA4024.5000909@bootc.net>
	<FCF3184D-CE4F-471C-B66C-0F671795FD3C@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B626017762@ORSMSX102.amr.corp.intel.com>
	<4F048861.8070501@bootc.net> <4F12B42C.9030803@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B62621F0B1@ORSMSX102.amr.corp.intel.com>
	<4F144A76.3050703@bootc.net> <4F64B4E2.20208@bootc.net>
	<4F64CFCB.7060702@bootc.net>
	<9BBC4E0CF881AA4299206E2E1412B6260E512E0C@ORSMSX102.amr.corp.intel.com>
Emacs: the only text editor known to get indigestion.
Date: Mon, 19 Mar 2012 16:19:32 +0000
In-Reply-To: <9BBC4E0CF881AA4299206E2E1412B6260E512E0C@ORSMSX102.amr.corp.intel.com>
	(Carolyn Wyborny's message of "Mon, 19 Mar 2012 14:59:41 +0000")
Message-ID: <87r4wova0b.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-dcc1.aftenposten.no-Metrics: spindle 1215; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Mar 2012, Carolyn Wyborny stated:

> So, at least we are clear in your situation, the ASPM needs to be
> disabled. Please let me know if there are continued problems after
> booting with pcie_aspm=off.

If you look further down in
<http://sourceforge.net/tracker/index.php?func=detail&aid=3170405&group_id=42302&atid=447449>
you'll see that I tested that, and it doesn't work :( even if it did
work, it shouldn't be needed: the driver attempts to turn off PCIe ASPM
on affected NICs, and fails, apparently because *something* turns it
back on again.

-- 
NULL && (void)
