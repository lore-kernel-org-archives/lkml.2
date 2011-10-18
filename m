Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1JRJRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:17:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1JRJRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:17:16 -0400
Date: Tue, 18 Oct 2011 11:17:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>, keithp@keithp.com
Subject: Re: MacBook Air (4,2): Screen working in full resolution (keithp
 tree, fix-edp-vdd-power branch)
In-Reply-To: <20111017233927.GA2292@schottelius.org>
Message-ID: <alpine.LNX.2.00.1110181115570.3541@pobox.suse.cz>
References: <20111017215114.GB1408@schottelius.org> <20111017223127.GC1408@schottelius.org> <20111017233927.GA2292@schottelius.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Nico Schottelius wrote:

> Update:
> 
> I've merged Keith's and Jiris trees together, they apply cleanly.
> 
> Even better, the result compiles fine and the resulting kernel boots,
> supports the fn-key, the touchpad AND has a working resolution of
> 1440x900!
> 
> I've put up the resulting source tree [0], [1], so until the the changes of both
> trees are merged back into Linus' tree and afterwards are pulled from the
> distributions, other MacBook Air Linux users have a working version.
> 
> Short version at [2]
> 
> Cheers,
> 
> Nico
> 
> [0] http://git.schottelius.org/?p=foreign/linux-keith-jiri-mba;a=summary
> [1] git://git.schottelius.org/foreign/linux-keith-jiri-mba
> [2] http://www.nico.schottelius.org/blog/macbook-air-42-touchpad-keyboard-correct-screen-resolution/

Thanks for verifying. I am planning to push it to Linus once 3.2 merge 
window opens.

-- 
Jiri Kosina
SUSE Labs
