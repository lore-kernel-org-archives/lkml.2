Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1JWITF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:19:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43428 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1JWIS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:18:59 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Jyrki Kuoppala <jkp@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Fix to qt1010 tuner frequency selection (media/dvb)
Date: Sun, 23 Oct 2011 09:18:54 +0100
Message-ID: <2657078.NsMWCJCMlO@valkyrie>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc10cc+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <4E9FA779.5040406@iki.fi>
References: <4E528FAE.5060801@iki.fi> <2165330.TqTdf0zloM@valkyrie> <4E9FA779.5040406@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 Oct 2011 07:45:45 Jyrki Kuoppala wrote:
> I think my problem frequency has also been at the later spot. It is possible
> there is something more complicated going on at 474 MHz - so based on your
> testing, it's best to apply just the latter change, at least for now.
> 
> Jyrki
> 
> 
> 
> +    else if (freq<   546000000) rd[15].val = 0xd6; /* 546 MHz */
> 
> +    else if (freq<   546000000) rd[15].val = 0xd6; /* 546 MHz */

Are you going to resubmit the patch with just these changes (you can add my 
Tested-by to that), or if you want, I can take care of resubmitting it?

-Carlos
