Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1FAG0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:26:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50554 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab1FAG0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:26:17 -0400
Date: Wed, 1 Jun 2011 08:26:07 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Worsley <amworsley@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] init, calibrate: Drop annoying warning
Message-ID: <20110601062607.GC21247@aftab>
References: <1306866541-17090-1-git-send-email-bp@amd64.org>
 <BANLkTimZ4xUEW1ZSZ7eQ9A9SdtBh6MjdDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimZ4xUEW1ZSZ7eQ9A9SdtBh6MjdDQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 07:04:59PM -0400, Andrew Worsley wrote:
> I can see your point - it's useful when debugging the bogomips issue -
> but if it's working it's not relevant.
> Would be nice to have an extra level of verbose debug or a debug
> branch of the file or perhaps just a relevant comment
> that would easily allow it to be found and reverted to re-enable debug
> if people want to debug this stuff again.

Well, your patch either fixes the issue so the debug statements can go
or it doesn't and needs more hammering :).

> That said I would suggest just changing the comment (I don't know how
> to just submit a comment change?) to something like:
> 
> "Drop calibrate_delay_direct() KERN_DEBUG printk related to bogomips
> calculation as it appears when booting
> every core on setups with 'ignore_loglevel' for people who want to
> test latest kernels and scan dmesg for possible issues.
> and this information isn't very useful to the widest audience of
> kernel boot message gazers."

Fair enough, will change and resubmit.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
