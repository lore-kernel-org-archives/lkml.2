Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1L1Qh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:37:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1L1QhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:37:25 -0500
Date: Wed, 28 Dec 2011 17:37:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] b43: fix regression in PIO case
In-Reply-To: <4EFA5E9B.8040106@lwfinger.net>
Message-ID: <Pine.LNX.4.64.1112281735380.24324@axis700.grange>
References: <alpine.DEB.2.00.1112261608140.12108@axis700.grange>
 <alpine.DEB.2.00.1112261824000.12108@axis700.grange>
 <CACna6ry1tKXtUSQHknkEbzBq_gZUyxn1-9Guba2a56xzx242SA@mail.gmail.com>
 <alpine.DEB.2.00.1112272359240.6684@axis700.grange> <4EFA58FD.9060605@lwfinger.net>
 <alpine.DEB.2.00.1112280052030.9949@axis700.grange> <4EFA5E9B.8040106@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:frrtHVGMwW1vA88QgHST8ZqZ8EKliMxWlBxYmm9ACUk
 dYFzPsBqnH6fN+/ziuAE3+zahtwcH+rU24mmad9g8RAA+wPzoG
 dpewsRAs/+WCVc9UBtjXNccNbhfuD0MdNbWLAGxLTF8gj9QCkj
 tUB8lPUHAAXejHbAoMCkkDe08y8QEZUc6fYpuJkKFxvwcI6cC1
 fKGOntNtfLYclnpcze+fic7e/haLLYgli8nNuzQkmbJzZ6qhum
 tntX4KhJhVs5P8EoiAd0SjAHXXt9aMgRrCoHeeYNUb9Cw2Mqji
 gfJX9yWes8mz8XpKlhjfUcVFb1H1TVbDwHrlx5BNrz9Ac5+atw
 Gfql4VkZVbqUqfPU4spJ3/RA/tOv5QP5YmzTeXNgHFzuccTTf8
 WOMRlJ8ghbE/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011, Larry Finger wrote:

[snip]

> No, you are right. I misread the code. Your patch above would work and is
> probably as clean as one can expect.

John, Linus, please ack / pull the original patch from this thread into 
3.2.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
