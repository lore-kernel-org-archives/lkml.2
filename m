Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab0HDWoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:44:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742Ab0HDWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:43:54 -0400
Date: Wed, 4 Aug 2010 15:42:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Cc: linux-kernel@vger.kernel.org, Trevor Keith <tsrk@tsrk.net>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fixed resource leak in scripts/mod/modpost.c
Message-Id: <20100804154248.866f8eb9.akpm@linux-foundation.org>
In-Reply-To: <1280925523.4449.158.camel@alex-desktop>
References: <1280925523.4449.158.camel@alex-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Aug 2010 15:38:43 +0300
Alexey Fomenko <ext-alexey.fomenko@nokia.com> wrote:

> sec2annotation returns malloc'ed buffer directly to printf as an
> argument. Patch lets free this buffer after printing. 
> 
> 
> [0001-fixed-resource-leak-in-scripts-mod-modpost.c.patch  text/x-patch (5.3KB)]
> >From 57bde7f335730f95eac75bcec5a27fb6686df25a Mon Sep 17 00:00:00 2001
> From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
> Date: Tue, 27 Jul 2010 17:59:04 +0300
> Subject: [PATCH] fixed resource leak in scripts/mod/modpost.c
> 

Against 2.6.35:

patching file scripts/mod/modpost.c
Hunk #1 succeeded at 1195 (offset 37 lines).
Hunk #2 FAILED at 1221.
Hunk #3 FAILED at 1243.
Hunk #4 FAILED at 1268.
Hunk #5 FAILED at 1301.
Hunk #6 FAILED at 1318.
5 out of 6 hunks FAILED -- saving rejects to file scripts/mod/modpost.c.rej

please check up on that.

Please also cc Rusty on this change.
