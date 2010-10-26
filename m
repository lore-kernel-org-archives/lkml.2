Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab0JZNO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:14:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36998 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab0JZNOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:14:25 -0400
Date: Tue, 26 Oct 2010 15:14:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Tim Bird <tim.bird@am.sony.com>, andi@firstfloor.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] archs: add ioremap_change_write_prot
Message-ID: <20101026131423.GA29961@basil.fritz.box>
References: <4CC3F13B.4030107@gmail.com>
 <AANLkTim460pm6QNgUh+C0p=D3Ppu7Q3Dx1j2PNd7Amdr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim460pm6QNgUh+C0p=D3Ppu7Q3Dx1j2PNd7Amdr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry to re-open the topic, but I'd like to receive any
> comments/feedback about this patch.

The name of the wrapper seems wrong -- this has nothing to do with IO.

I must admit I'm also not a fan of wrappers, why not call the set_memory_*
functions directly and implement them for the other archs too?

Other than that it seems reasonable.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
