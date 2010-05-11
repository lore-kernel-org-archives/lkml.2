Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab0EKIrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:47:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403Ab0EKIrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:47:01 -0400
Date: Tue, 11 May 2010 10:46:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: linux-input@vger.kernel.org, chatty@enac.fr, dmitry.torokhov@gmail.com,
       micki@n-trig.com, linux-kernel@vger.kernel.org, guy.paradis@n-trig.com
Subject: Re: [PATCH 0/3] N-Trig improved filtering
In-Reply-To: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
Message-ID: <alpine.LNX.2.00.1005111045400.28092@pobox.suse.cz>
References: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010, Rafi Rubin wrote:

> On a side note, I haven't really used module parameters and sysfs before.
> What I wrote works fine, and I tried to follow the style of examples.  Still
> I'd like some feedback of what I did wrong, or right.

Hi Rafi,

sorry, it took me quite some time to go through and review the patches. I 
have now applied them.

Could you please also submit a separate one, adding the sysfs entries 
documentation (Documentation/ABI/testing would be the proper place).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
