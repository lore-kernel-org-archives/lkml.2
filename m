Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0HRRoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:44:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35327 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0HRRoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:44:18 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: miklos@szeredi.hu, jkmalinen@gmail.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20100818141712.GN31363@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 18 Aug 2010 15:17:12 +0100)
Subject: Re: [PATCH] uml: fix hostfs lookup
References: <E1OlimD-0006YS-3T@pomaz-ex.szeredi.hu>
 <E1Olirt-0006aI-DV@pomaz-ex.szeredi.hu> <20100818141712.GN31363@ZenIV.linux.org.uk>
Message-Id: <E1OlmgL-0006zB-3l@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Aug 2010 19:44:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010, Al Viro wrote:
> On Wed, Aug 18, 2010 at 03:39:49PM +0200, Miklos Szeredi wrote:
> > Oops, sorry.  Off-by-one bug crept in there.
> 
> It's already fixed in the queue (see #untested in vfs-2.6)

Your fix is still wrong for the pathological case of len == p - name,
that's why I opted not to use strlcpy.

Thanks,
Miklos

