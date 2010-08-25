Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab0HYNab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:30:31 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57691 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab0HYNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:30:30 -0400
Date: Wed, 25 Aug 2010 15:30:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checksyscalls: Fix stand-alone usage
Message-ID: <20100825133027.GA1745@merkur.ravnborg.org>
References: <alpine.DEB.2.00.1008251221270.22455@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008251221270.22455@ayla.of.borg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 12:22:40PM +0200, Geert Uytterhoeven wrote:
> The usage help in the comments
>   - refers to the wrong script name,
>   - doesn't mention that $srctree must be set.
> 
> Hence correct the script name, and derive the source tree path from the script
> path, so we no longer need to rely on $srctree being set by the caller.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
