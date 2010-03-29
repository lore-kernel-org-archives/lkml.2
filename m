Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0C2LKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:10:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:43488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab0C2LKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:10:21 -0400
Message-ID: <4BB08A8E.6050101@kernel.org>
Date: Mon, 29 Mar 2010 20:10:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>
Subject: Re: linux-next: build failure after merge of the slabh tree
References: <20100329160250.1515a2ca.sfr@canb.auug.org.au>	<s5hy6hb4p6u.wl%tiwai@suse.de> <20100329173852.3550bbea.sfr@canb.auug.org.au>
In-Reply-To: <20100329173852.3550bbea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 11:10:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On 03/29/2010 03:38 PM, Stephen Rothwell wrote:
> Again, thanks.  They were just one liner because I found them one at a
> time :-(

Yikes, sorry about many failures.  Now that I think about it, it
probably would have been wiser to run the conversion script on top of
linux-next so that new ones in linux-next aren't missed by default.
I'll do that and send out respective patches to each subsystem tree.

Thank you very much for taking the trouble to fix them up.  I'll soon
submit more comprehensive fix up patches for code in linux-next but
not in mainline.

-- 
tejun
