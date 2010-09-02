Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0IBVxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:53:17 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35567 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0IBVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:53:16 -0400
Date: Thu, 2 Sep 2010 22:53:14 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH 82/91] arch/mips/Kconfig Update broken web addresses in
 the arch directory.
In-Reply-To: <1283462022-8024-7-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LFD.2.00.1009022247190.410@eddie.linux-mips.org>
References: <1283462022-8024-1-git-send-email-justinmattock@gmail.com> <1283462022-8024-7-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Justin P. Mattock wrote:

> The below patch updates a broken web address that is no longer
> working due to company buyout, and/or change of location.
> (Please have a look through, and let me know if any of them
> need to be changed, and I'll resend an updated patch).
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/mips/Kconfig |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 3ad59dd..984b14e 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -2178,7 +2178,8 @@ config TC
>  	  TurboChannel is a DEC (now Compaq (now HP)) bus for Alpha and MIPS
>  	  processors.  Documentation on writing device drivers for TurboChannel
>  	  is available at:
> -	  <http://www.cs.arizona.edu/computer.help/policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
> +	  <http://web.archive.org/web/*/http://www.cs.arizona.edu/computer.help/
> +	  policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
>  
>  #config ACCESSBUS
>  #	bool "Access.Bus support"

 This is more <linux-mips@linux-mips.org>; we don't have TURBOchannel 
support for the Alpha (yet?).

 Anyway, a better source should be available; let me see.  Also the 
original document could not have been the most appropriate one -- it looks 
more like a Digital Unix reference, while a set of hardware- and 
firmware-level documents used to be available for TURBOchannel devices 
(and HP probably still publishes them by inertia ;) ).

 Either way, thanks for tracking down these broken links.

  Maciej
