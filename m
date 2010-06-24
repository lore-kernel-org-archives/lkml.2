Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0FXJxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:53:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60826 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab0FXJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:53:00 -0400
From: Andi Kleen <andi@firstfloor.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 37/52] fs: icache lazy lru
References: <20100624030212.676457061@suse.de>
	<20100624030731.563540438@suse.de>
Date: Thu, 24 Jun 2010 11:52:58 +0200
In-Reply-To: <20100624030731.563540438@suse.de> (npiggin@suse.de's message of
	"Thu, 24 Jun 2010 13:02:49 +1000")
Message-ID: <87lja4ahad.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de writes:

> Impelemnt lazy inode lru similarly to dcache. This will reduce lock
> acquisition and will help to improve lock ordering subsequently.

Or just drop inode LRU completely and only rely on the dcache for that?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
