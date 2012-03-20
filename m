Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030677Ab2CTROy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:14:54 -0400
Received: from mail1.windriver.com ([147.11.146.13]:43301 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2CTROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:14:53 -0400
Message-ID: <4F68BAFB.7070301@windriver.com>
Date: Tue, 20 Mar 2012 12:14:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] kdb:  Avoid using dbg_io_ops until it is initialized
References: <4F68B180.8030709@am.sony.com>
In-Reply-To: <4F68B180.8030709@am.sony.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 11:34 AM, Tim Bird wrote:
> Jason,
>
> This patch has apparently fallen through the cracks.  Can you please apply?
> This fixes a kernel panic for a use case where I'm setting a breakpoint
> from kdb_cmds on kernel startup.  In this case, without this patch
> dbg_io_ops is used before it is initialized.

Many thanks Tim.

I'll review/regression test this and add it to the merge queue.   I found another patch from you in the same week from last year that I will also review.  I am not exactly sure why these never made it to my review list, but what once was lost is now found.

Cheers,
Jason.
