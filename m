Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1C2Hgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:36:47 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:50201 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1C2Hgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:36:46 -0400
Date: Tue, 29 Mar 2011 09:36:33 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: catalin.marinas@arm.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: update documentation
Message-ID: <20110329073632.GB10163@osiris.boeblingen.de.ibm.com>
References: <1300978173-9983-1-git-send-email-dbaluta@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300978173-9983-1-git-send-email-dbaluta@ixiacom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 04:49:33PM +0200, Daniel Baluta wrote:
> Besides x86 and arm, kmemleak now supports powerpc, sparc, sh,
> microblaze and tile.
> 
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
> ---
>  Documentation/kmemleak.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
> index 34f6638..090e6ee 100644
> --- a/Documentation/kmemleak.txt
> +++ b/Documentation/kmemleak.txt
> @@ -11,6 +11,7 @@ with the difference that the orphan objects are not freed but only
>  reported via /sys/kernel/debug/kmemleak. A similar method is used by the
>  Valgrind tool (memcheck --leak-check) to detect the memory leaks in
>  user-space applications.
> +Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.

You missed s390.
