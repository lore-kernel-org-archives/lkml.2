Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2ENBIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 21:08:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55801 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2ENBIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 21:08:50 -0400
Date: Mon, 14 May 2012 09:09:32 +0800
From: "majianpeng" <majianpeng@gmail.com>
To: "Gilad Ben-Yossef" <gilad@benyossef.com>,
        "Christoph Lameter" <cl@linux.com>
Cc: "linux-mm" <linux-mm@kvack.org>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
References: <201205111008157652383@gmail.com>,
 <alpine.DEB.2.00.1205111113460.31049@router.home>
Subject: Re: Re: [PATCH] slub: missing test for partial pages flush work in flush_all
Message-ID: <201205140909294844918@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, May 11, 2012 at 7:14 PM, Christoph Lameter <cl@linux.com> wrote:
> Didn't I already ack this before?
>
> Acked-by: Christoph Lameter <cl@linux.com>
>

>Yes, you did, but the patch description and title was lacking and
>Majianpeng kindly fixed it, hence the re-send, I guess.

>I've added Andrew, since he took my original commit that introduces
>the bug that this patch by Majianpeng  fixes (and also LKML).

>This fix really needs to get into 3.4, otherwise we'll be breaking
>slub. What's the best way to go about that?

>Thanks!
>Gilad


Sorry for late to relay. I rewrited the comment and resend.
I have a question to ask:because the patch fixed by others,for example Christoph Lameter, Gilad.
Should I add sogine-off by them in the patch?
																	Thanks all!

------------------				 
majianpeng
2012-05-14


