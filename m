Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1EHUDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 16:03:14 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:50552 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1EHUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 16:03:12 -0400
Message-ID: <4DC6F6D8.40303@ece.ntua.gr>
Date: Sun, 08 May 2011 23:02:32 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110502 Lightning/1.0b3pre Lanikai/3.1.10
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org
CC: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [PATCH 0/2] ppc/cleaup: Fix compiler warnings
References: <1304777491-7947-1-git-send-email-psomas@cslab.ece.ntua.gr>
In-Reply-To: <1304777491-7947-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Sun, 08 May 2011 23:02:36 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2011 05:11 PM, Stratos Psomadakis wrote:
> Fix compiler warnings in ppc code, which can lead to build failure, if
> CONFIG_PPC_WERROR is set (default).
>
>  arch/powerpc/include/asm/pgtable-ppc64.h |   13 ++++++-------
>  arch/powerpc/kernel/Makefile             |    2 +-
>  2 files changed, 7 insertions(+), 8 deletions(-)
forgot to cc the maintainers

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

