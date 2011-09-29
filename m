Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1I2WgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:36:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58745 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab1I2WgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:36:20 -0400
Date: Thu, 29 Sep 2011 15:36:18 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        viro@zeniv.linux.org.uk,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Clean up brlocks/lglocks
Message-Id: <20110929153618.c761d9bb.akpm00@gmail.com>
In-Reply-To: <1317252644-5146-1-git-send-email-andi@firstfloor.org>
References: <1317252644-5146-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011 16:30:44 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> lglocks and brlocks are currently generated with some complicated macros
> in lglock.h. But there's no reason, I can see, to not just use common
> utility functions that get pointers to the lglock.

https://lkml.org/lkml/2011/8/24/454 makes me suspect that there's a bug
in brlocks, or they're being misused in some way.  However the code
doesn't have an identifiable maintainer, so things just sit there.

I guess these problems don't preclude cosmetic cleanups, but it's all a
bit regrettable.

