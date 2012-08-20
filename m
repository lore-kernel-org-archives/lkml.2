Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2HTJQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:16:15 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:7717 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617Ab2HTJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:16:12 -0400
X-IronPort-AV: E=Sophos;i="4.77,796,1336341600"; 
   d="scan'208";a="153403004"
Date: Mon, 20 Aug 2012 11:15:53 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Takashi Iwai <tiwai@suse.de>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 0/10] fix error return code
In-Reply-To: <s5hobm6q6h0.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.02.1208201115050.1922@localhost6.localdomain6>
References: <1345359780-18647-1-git-send-email-Julia.Lawall@lip6.fr> <s5hobm6q6h0.wl%tiwai@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Takashi Iwai wrote:

> At Sun, 19 Aug 2012 09:02:51 +0200,
> Julia Lawall wrote:
>>
>> These patches fix cases where the return code appears to be unintentially
>> nonnegative.
>
> The patch 10/10 seems missing.  Or are all 9 patches?  The patch
> number suddenly changes to X/9 from 4.
>
> In anyway, the patches 3, 5, 6, 7, 8 and 9 are applied.
> I leave patches 1, 2 and 4 to Mark.

Sorry, I thought I fixed that, but I guess not enough.  Patches 4 and 5 
were the same originally.  There is no patch 10.

julia
