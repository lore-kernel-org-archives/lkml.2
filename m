Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0FXP7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:59:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:44307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0FXP7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:59:12 -0400
Date: Fri, 25 Jun 2010 01:59:04 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 37/52] fs: icache lazy lru
Message-ID: <20100624155904.GK10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030731.563540438@suse.de>
 <87lja4ahad.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lja4ahad.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 11:52:58AM +0200, Andi Kleen wrote:
> npiggin@suse.de writes:
> 
> > Impelemnt lazy inode lru similarly to dcache. This will reduce lock
> > acquisition and will help to improve lock ordering subsequently.
> 
> Or just drop inode LRU completely and only rely on the dcache for that?

Possible, yes. There was some talking about it. I prefer not to do
anything too controversial yet if possible :)

