Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1CPQ4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:56:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34386 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1CPQ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:56:38 -0400
Date: Wed, 16 Mar 2011 17:56:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH] oprofile: Allow setting EDGE/INV/CMASK for Intel counter events
Message-ID: <20110316165634.GA11094@one.firstfloor.org>
References: <1299870748-13319-1-git-send-email-andi@firstfloor.org> <20110316150450.GO31407@erda.amd.com> <20110316152757.GA12845@tassilo.jf.intel.com> <20110316154553.GQ31407@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316154553.GQ31407@erda.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Shouldn't something like the follwing work (assuming the umask table
> is modified)?
> 
>  opcontrol --event SOME_EVENT:100000:0x00800000 ...

I think there was some problem with this when I tried it.

Besides I'm more interested in using named events for this;
the raw numbers are quite evil. So this needs new user space
in any case.

-Andi
