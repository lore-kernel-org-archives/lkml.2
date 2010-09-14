Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab0INBWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 21:22:51 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:10520 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752073Ab0INBWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 21:22:49 -0400
Message-ID: <4C8ECDFE.6010906@snapgear.com>
Date: Tue, 14 Sep 2010 11:21:02 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k
 tree
References: <20100914105129.02eb5b13.sfr@canb.auug.org.au>
In-Reply-To: <20100914105129.02eb5b13.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2010 01:22:21.0353 (UTC) FILETIME=[4774A190:01CB53AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stephen,

Stephen Rothwell wrote:
> Today's linux-next merge of the m68knommu tree got a conflict in
> arch/m68k/sun3/sun3ints.c between commit
> 72fe185cd9acbfc6e8a7afa884ae1152be706e52 ("m68k/m68knommu: Remove dead
> SMP config option") from the m68k tree and commit
> 5313b581e4efc214c6132d32f580db6668e5c5a8 ("arch/m68k{,nommu}: Removing
> dead SMP config option") from the m68knommu tree.
> 
> These appear to be the same patch with some formatting differences.  I
> used the version from the m68k tree.

Looks like Geert added the same patch to the m68k git tree.
I'll drop it from the m68knommu git tree.

Thanks
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
