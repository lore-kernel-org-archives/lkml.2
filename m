Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2KPRq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:46:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2KPRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:46:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Subject: Re: [GIT PULL] arm-soc: Xilinx zynq changes for v3.8
Date: Fri, 16 Nov 2012 17:46:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "arm@kernel.org" <arm@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        Nick Bowler <nbowler@elliptictech.com>,
        Josh Cartwright <josh.cartwright@ni.com>, John Linn <linnj@xilinx.com>
References: <CAHTX3dLdGie9gtxbPq_gb8BLao7YYohqQWZFg3LzyNHxu=imdg@mail.gmail.com> <201211161654.23470.arnd@arndb.de> <52241ede-3d28-43fc-967d-36ab64d52592@CH1EHSMHS038.ehs.local>
In-Reply-To: <52241ede-3d28-43fc-967d-36ab64d52592@CH1EHSMHS038.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161746.15629.arnd@arndb.de>
X-Provags-ID: V02:K0:d2fy4KqUwWQIkl+fsa8v5ao4+WXGSQ0sNlu+BlsWp6H
 Co1vt41Te8p1PZDdLExQRVADqJsrq2QR5Nmq9Xc8qAgZuqmW6X
 /HXDmT2maUBEMqwTtX+dSEnEhTntsmuv0amkGTOry0FpUiku5a
 m/R4X36aYLJI678sVs0cnjyGQP4Wu/IrNDPn2AO+lodmEFnHlb
 rS/mLtiBzXEEcAbJL1G3BHUs6N5eSdL4/lJ5CqiuP0chhtkFFQ
 neX78vIZfjohvhO5vfmo/It6oeKGl1ZvfrVrvgVqaEVDkWEB/1
 CN45wtQNE7Qyp2o2rKU27n7nKVYodjLL4GU+9c+afzTixx/daU
 SJGRkUhat7ZRdFscZivg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2012, Michal Simek wrote:
> > * Please provide a description of the series that I can put into the merge
> > changeset, either in the introductory mail or (better) into the signed tag that
> > you send (git tag -s). Have a look at how Tony Lindgren does this, he writes the
> > best descriptions.
> 
> No. Do you have a link?

See for example http://www.spinics.net/lists/arm-kernel/msg207098.html

This is a particularly long explanation, it doesn't normally have to
be that verbose, but I probably won't ever complain about a changeset
text being too long rather than too short, independent of whether
it's a patch or a pull request.

	Arnd
