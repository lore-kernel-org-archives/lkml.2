Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2BGU7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:59:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2BGU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:59:36 -0500
Date: Tue, 7 Feb 2012 12:59:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: axel.lin@gmail.com
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] leds: lm3530: Fix setting pltfm->als_vmax
Message-Id: <20120207125926.0f5722b2.akpm@linux-foundation.org>
In-Reply-To: <CAF+7xW=Y2kVCXHhGFM5YNLAKE05MctcC4ZoJiq6KEagrpV9fHg@mail.gmail.com>
References: <1328595786.5274.6.camel@phoenix>
	<B567DBAB974C0544994013492B949F8E3812ED4697@EXMAIL03.scwf.nsc.com>
	<CAF+7xW=Y2kVCXHhGFM5YNLAKE05MctcC4ZoJiq6KEagrpV9fHg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012 19:12:41 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> > This patch makes sense and fixes wrong range of the ALS input voltage.
> > It works well on the real board.
> > Thanks.
> >
> > Acked-and-tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> >
> > BTW, I'd suggest that 'pltfm' is replaced with 'pdata' if below patch has been updated.
> > [PATCH v4 5/5] leds-lm3530: replace pltfm with pdata.
> 
> Well, I will redo the patch if Andrew takes your patch serial first.
> But I guess Andrew may take this one first for 3.3.
> 

I applied "leds: lm3530: Fix setting pltfm->als_vmax" as-is for 3.3 and
fixed up my copy of "leds-lm3530: replace pltfm with pdata".
