Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0C2DaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 23:30:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45362 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab0C2DaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 23:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D45VO4Wo3YJqRBBDLDv3rYLLyppwpseXL62OhmYMoDR6goxOEqDPAGeUgOfOTm16y9
         gE7gnvAZ/aQocgsBov+/BBvXLYAnlCnvFbO8lmpZIvJXTOizMJCunt1kWO1T9ceeruEH
         HVWbhk1NPX2PpkbIX3H1OnXRN2M/jUwn+Nmsg=
Date: Mon, 29 Mar 2010 05:23:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
Message-ID: <20100329032332.GK5116@nowhere>
References: <20100328043446.GA11748@nowhere> <20100328.190235.125554595.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100328.190235.125554595.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 07:02:35PM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Sun, 28 Mar 2010 06:34:49 +0200
> 
> > I get kernel crashes each time I use perf with callchains
> > on sparc 64.
> > 
> > It triggers with a simple:
> > 
> > 	perf record -a -f -g sleep 1
> > 
> > I'm attaching two different crashlogs, as it seem to happen
> > randomly, and also my config.
> 
> Is your 'perf' a 64-bit or 32-bit binary.  How about the
> 'sleep' binary?


Both are 32 bits binaries.

