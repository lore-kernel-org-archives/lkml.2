Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2BARwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:52:51 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:32852 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2BARwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:52:50 -0500
Date: Wed, 01 Feb 2012 12:52:45 -0500 (EST)
Message-Id: <20120201.125245.681472105466012081.davem@davemloft.net>
To: jmorris@namei.org
Cc: torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Fixes for MPI library
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1202020037340.20463@tundra.namei.org>
References: <alpine.LRH.2.00.1202020037340.20463@tundra.namei.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 09:52:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Morris <jmorris@namei.org>
Date: Thu, 2 Feb 2012 00:39:46 +1100 (EST)

> Hi Linus,
> 
> Please pull these fixes for the MPI library.
> 
> Thanks to Tetsuo Handa for reviewing and analyzing the code.
> 
> 
> The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
>   Linus Torvalds (1):
>         Linux 3.3-rc2
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
> 
> Dmitry Kasatkin (11):
>       lib/mpi: added missing NULL check
>       lib/mpi: replaced MPI_NULL with normal NULL
>       lib/mpi: return error code on dividing by zero
>       lib/mpi: checks for zero divisor length
>       lib/mpi: removed unused functions
>       lib/digsig: additional sanity checks against badly formated key payload
>       lib/digsig: pkcs_1_v1_5_decode_emsa cleanup
>       lib/mpi: check for possible zero length
>       lib/mpi: added comment on divide by 0 case
>       lib/mpi: added missing NULL check
>       lib/digsig: checks for NULL return value

What happened to the sparc 32-bit build fixes I posted to Dmitry the other
week?
