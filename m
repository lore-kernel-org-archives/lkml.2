Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1GXB5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 21:57:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58732 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1GXB4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 21:56:54 -0400
Date: Sun, 24 Jul 2011 03:56:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Matt Mackall <mpm@selenic.com>, NeilBrown <neilb@suse.de>,
        Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110724015652.GX8006@one.firstfloor.org>
References: <20110722163335.2df4f6ca@notabene.brown> <1311363269.14555.261.camel@calx> <20110722205922.GS8006@one.firstfloor.org> <1311369102.14555.268.camel@calx> <20110722214732.GW8006@one.firstfloor.org> <20110722221039.GB10749@fieldses.org> <20110722223158.GC10749@fieldses.org> <20110723085915.308ddc02@notabene.brown> <1311379661.20898.23.camel@calx> <20110723013809.GA12174@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723013809.GA12174@fieldses.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> with a stat.  So either you have a clock good enough to give a distinct
> timestamp for all of those, or you fall back on a global counter that
> ends up serializing all IO.  I think.  I admit I'm not sure I understand

Not global counter, but per inode. That's very reasonable because there's
already locking on the inode level.

-Andi
