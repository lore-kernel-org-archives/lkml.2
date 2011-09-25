Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1IYLQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:16:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1IYLQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:16:37 -0400
Date: Sun, 25 Sep 2011 13:16:41 +0200
From: Heinz Diehl <htd@fritha.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS cpu scheduler and skip list implementation
Message-ID: <20110925111641.GA1903@fritha.org>
References: <201109240945.58879.kernel@kolivas.org>
 <20110925090417.GA19813@fancy-poultry.org>
 <201109251913.28120.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109251913.28120.kernel@kolivas.org>
Organization: private site
X-OpenPGP-KeyID: 0xE9002778
X-OpenPGP-Fingerprint: C661 CE20 7105 B0DB 49B5  CDB2 298C 801B E900 2778
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
X-Provags-ID: V02:K0:YEgtPMwn4//DZ4GEctwoTo8r+cf4ETRg/QB68M3YjsS
 sh5DAEH4vAS/9LamlIQtA+JJDnnzAP8yXiljrQyJ5nd/v6nAgl
 20NJN58lJGdgJdPTSlPp25x4j2/bp/fC+T3FtNcg5FhKD1TvEV
 pZHiJkLyJICseYG2P1P6YjkFqNjbBG1j90JG3swFF+iILEPGYI
 hDFJMvzXfuAZF271M5nsaS673/l1XfnLlhtI11mHbp73k6/VQ1
 ewk8w7MolcqmzYLSk038hTJ3IO0XF6pBa9PfXY7F7VPxARIs3f
 TKWSZZkA8r1mOKf3sojCO4oam8VHmGf2dblOhrVZlXcyN/cgaA
 TrJhdtIuqlP1rLHv93gAAXX61sO8txWDl+SBM+ONY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.09.2011, Con Kolivas wrote: 

> I'm guessing you did not configure in the BFS CPU scheduler, which is pretty 
> much mandatory with this patch.

Of course, I did:

[root@wildsau ~]# cat /usr/src/linux/.config | grep BFS
CONFIG_SCHED_BFS=y
CONFIG_HUGETLBFS=y
CONFIG_BFS_FS=m


