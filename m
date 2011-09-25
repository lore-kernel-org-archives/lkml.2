Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab1IYLTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:19:14 -0400
Received: from home.kolivas.org ([59.167.196.135]:42494 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202Ab1IYLTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:19:13 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Heinz Diehl <htd@fritha.org>
Subject: Re: BFS cpu scheduler and skip list implementation
Date: Sun, 25 Sep 2011 21:19:10 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38.4-ck1; KDE/4.6.2; x86_64; ; )
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org
References: <201109240945.58879.kernel@kolivas.org> <201109251913.28120.kernel@kolivas.org> <20110925111641.GA1903@fritha.org>
In-Reply-To: <20110925111641.GA1903@fritha.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109252119.10798.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Sep 2011 21:16:41 Heinz Diehl wrote:
> On 25.09.2011, Con Kolivas wrote:
> > I'm guessing you did not configure in the BFS CPU scheduler, which is
> > pretty much mandatory with this patch.
> 
> Of course, I did:
> 
> [root@wildsau ~]# cat /usr/src/linux/.config | grep BFS
> CONFIG_SCHED_BFS=y
> CONFIG_HUGETLBFS=y
> CONFIG_BFS_FS=m

Can you send me your config then please? Offlist is fine.

-- 
-ck
