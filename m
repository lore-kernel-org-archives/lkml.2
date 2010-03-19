Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0CSJxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 05:53:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:36321 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0CSJxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 05:53:23 -0400
Date: Fri, 19 Mar 2010 10:53:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a typo in sound/pci/hda/hda_local.h
In-Reply-To: <1268965573-11829-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1003191053120.18642@pobox.suse.cz>
References: <1268965573-11829-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010, Justin P. Mattock wrote:

> I think this should be automatic pin instead of ping.
> (but could be wrong).
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> ---
>  sound/pci/hda/hda_local.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
> index 7cee364..7a97f12 100644
> --- a/sound/pci/hda/hda_local.h
> +++ b/sound/pci/hda/hda_local.h
> @@ -361,7 +361,7 @@ struct hda_bus_unsolicited {
>  };
>  
>  /*
> - * Helper for automatic ping configuration
> + * Helper for automatic pin configuration
>   */

Applied, thanks Justin.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
