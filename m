Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0ETDD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:03:57 -0400
Received: from ozlabs.org ([203.10.76.45]:52961 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab0ETDD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:03:56 -0400
Date: Thu, 20 May 2010 13:03:24 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Fix string library functions
Message-ID: <20100520030324.GA31208@drongo>
References: <m2bpcdjcue.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2bpcdjcue.fsf@igel.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 08:15:21PM +0200, Andreas Schwab wrote:

> The powerpc strncmp implementation does not correctly handle a zero
> length, despite the claim in 0119536cd314ef95553604208c25bc35581f7f0a
> (Add hand-coded assembly strcmp).
> 
> Additionally, all the length arguments are size_t, not int, so use
> PPC_LCMPI and eq instead of cmpwi and le throughout.
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Looks fine to me.

Acked-by: Paul Mackerras <paulus@samba.org>
