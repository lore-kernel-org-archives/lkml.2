Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1FOWP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:15:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59660 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab1FOWPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M2E/VDqIPPT9vqjaz6viYroELjQBuPId3vahlQCwo/pC4Ye1u97xVmzxjDJLzW5ST0
         mDjBPsTeiHUjjmMxfXPSZM6M4qGrRVn/nZqvgaH14M/hvslAZAuir6daErSCB0aRxN6v
         c1HkeWUSyghwYjl+6WXjQgcJ3tAVzLXdF5+tQ=
Date: Thu, 16 Jun 2011 00:15:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sam Liao <phyomh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
Message-ID: <20110615221513.GA18579@somewhere.redhat.com>
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 02:44:19PM +0800, Sam Liao wrote:
> Add "caller/callee" option to support inverted butterfly report,
> in the inverted report (with caller option), the call graph start
> from the callee's ancestor. Users can use such view to catch system's
> performance bottleneck from a sysprof like view. Using this option
> with specified sort order like pid gives us high level view of call
> graph statistics.

Sam, can you give me your "Signed-off-by:" tag otherwise I can't apply
the patch.

Thanks.
