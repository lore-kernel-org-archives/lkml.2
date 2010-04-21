Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0DUUWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:22:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36168 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756414Ab0DUUV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:21:58 -0400
Date: Wed, 21 Apr 2010 21:26:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Sreedhara DS <sreedhara.ds@intel.com>
Subject: Re: [PATCH] IPC driver for Intel Mobile Internet Device (MID)
 platforms
Message-ID: <20100421212615.055b90d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100421131615.d8430a50.akpm@linux-foundation.org>
References: <20100409102629.22832.30883.stgit@localhost.localdomain>
	<20100421131615.d8430a50.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's be nice to have some words or a link describing what an IPC
> actually _is_.

"Inter-process" ("or" I guess) "communication"

I'll go through the other stuff. The driver is a few versions on from the
one you reviewed but quite a few of those problems are still present.

I'll then post up a new version to the platform driver list.

Alan
