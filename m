Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1FHHu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:50:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:53826 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1FHHuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:50:22 -0400
Date: Wed, 8 Jun 2011 09:50:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Kriwanek <mail@stefankriwanek.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the hid tree
In-Reply-To: <4DEF2412.3040707@stefankriwanek.de>
Message-ID: <alpine.LNX.2.00.1106080949470.22872@pobox.suse.cz>
References: <20110608130334.58c62a7d.sfr@canb.auug.org.au> <4DEF2412.3040707@stefankriwanek.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Stefan Kriwanek wrote:

> Hi Jiri,
> 
> I can only guess that this has to do with my patch not made by `git 
> --diff` but simply `diff -up 
> /dev/null/linux-2.6.39-speedlink/drivers/hid/hid-speedlink.c`
> 
> --- /dev/null	2011-05-27 13:53:55.863652998 +0200
> +++ linux-2.6.39-speedlink/drivers/hid/hid-speedlink.c	2011-05-27 18:00:34.719863577 +0200
> 
> I am sorry if I caused the disturbance. However, after reading 
> Documentation/SubmittitingPatches etc. I didn't know of any special 
> measure to undertake when adding new files - If so, maybe one should 
> consider updating the documention?.

Bah, no need to be sorry, it's my fault. Forgot to do 'git add' after I 
have resolved the conflict.

Fixed now in my tree and pushed out.

-- 
Jiri Kosina
SUSE Labs
