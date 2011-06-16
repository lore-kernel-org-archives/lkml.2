Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab1FPSjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:39:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:36061 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1FPSjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:39:48 -0400
Date: Thu, 16 Jun 2011 20:39:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/Trivial] docproc: cleanup brace placement
In-Reply-To: <alpine.LNX.2.00.1106151148070.2452@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106162039160.22872@pobox.suse.cz>
References: <alpine.LNX.2.00.1106151148070.2452@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Jesper Juhl wrote:

> The placement of the opening brace "{" after 'if' statements in 
> scripts/docproc.c is inconsistent. Most are placed on the same line as the 
> 'if' statement itself as per CodingStyle, but a few are not.
> This patch cleans up the inconsistency. We save a few source lines and the 
> file then uses the same style throughout, which is nice.

OK, why not. There is even quite a low chance of conflicting with anyone 
else.

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
