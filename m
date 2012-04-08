Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2DHT4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 15:56:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab2DHT4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 15:56:00 -0400
Date: Sun, 8 Apr 2012 21:55:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masanari Iida <standby24x7@gmail.com>, Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/V2] [trivial] Documentation: Fix typo in multiple files
 in Documentation
In-Reply-To: <4F80F288.1020305@landley.net>
Message-ID: <alpine.LNX.2.00.1204082152280.24006@pobox.suse.cz>
References: <1333727104-10181-1-git-send-email-standby24x7@gmail.com> <1333807980-26161-1-git-send-email-standby24x7@gmail.com> <4F80F288.1020305@landley.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2012, Masanari Iida wrote:

> Correcting multiple spelling typo in Documentation.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> 
> Cc: Rob Landley <rob@landley.net>
[ ... snip ... ]
> --- a/Documentation/scsi/ChangeLog.megaraid_sas
> +++ b/Documentation/scsi/ChangeLog.megaraid_sas
> @@ -521,7 +521,7 @@ i.	Register 16 byte CDB capability with scsi midlayer
>  3 Older Version   : 00.00.02.01 
>  
>  i.	New template defined to represent each family of controllers (identified by processor used). 
> -	The template will have defintions that will be initialised to appropritae values for a specific family of controllers. The template definition has four function pointers. During driver initialisation the function pointers will be set based on the controller family type. This change is done to support new controllers that has different processors and thus different register set.
> +	The template will have definitions that will be initialised to appropriate values for a specific family of controllers. The template definition has four function pointers. During driver initialisation the function pointers will be set based on the controller family type. This change is done to support new controllers that has different processors and thus different register set.

As this is a Changelog which is likely extracted from some vendor version 
of the driver (or from it's changelog, to be more precise), I think we 
shouldn't be touching that.

Could you please drop that hunk and resend it to me? I'll then be taking 
it together with Rob's ACK if there are no objections.

-- 
Jiri Kosina
SUSE Labs
