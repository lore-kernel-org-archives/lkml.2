Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2LJGKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:10:30 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:47294 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980Ab2LJGKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:10:24 -0500
X-IronPort-AV: E=Sophos;i="4.84,249,1355094000"; 
   d="scan'208";a="185340091"
Date: Mon, 10 Dec 2012 07:10:16 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Liam Girdwood <lrg@ti.com>,
        matthias@kaehlcke.net, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sound/soc/soc-core.c: drop kfree of devm_kzalloc's
 data
In-Reply-To: <20121210052334.GI10927@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.02.1212100709450.2213@localhost6.localdomain6>
References: <1354989680-25794-1-git-send-email-Julia.Lawall@lip6.fr> <20121210052334.GI10927@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012, Mark Brown wrote:

> On Sat, Dec 08, 2012 at 07:01:20PM +0100, Julia Lawall wrote:
>
>> The kfrees were introduced in b761c0ca.
>> I sent this a few months ago, and I still think it should be applied...
>
> I'm missing patches 1 and 2?

Sorry, I just resent the patch as is.  1 and 2 were I guess applied, 
because I odn't findthe problem any more.

julia
