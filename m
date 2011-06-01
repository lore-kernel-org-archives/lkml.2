Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab1FAHuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:50:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34393 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1FAHuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CkIFPvJJAhpfsCF0hL0wrxSy0+/dfhJD+dipYI976vvBttiI6xXrebRXE7ahNTXSzM
         scRvdNpBUG2NCd+YXVCMw/lYk3Z4BkmwRG27yAB4fPRVjs/fawLrSZfOcC5AmRD4hqB9
         aJwSMMWTVU13gcDpD1+qTWS8juNewZprqArFc=
Subject: Re: [PATCH -next] mtd: fix physmap.h warnings
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Woodhouse <dwmw2@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mtd@lists.infradead.org,
        linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <1306222943.2785.55.camel@localhost>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	 <20110523113709.4357b4ba.randy.dunlap@oracle.com>
	 <1306216431.2785.46.camel@localhost> <1306216683.2785.47.camel@localhost>
	 <20110524074020.GA9490@flint.arm.linux.org.uk>
	 <1306222943.2785.55.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 10:45:54 +0300
Message-ID: <1306914354.4405.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 10:42 +0300, Artem Bityutskiy wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Subject: [PATCH] mtd: fix physmap.h warnings
> 
> Fix build warnings in physmap.h:
> 
> include/linux/mtd/physmap.h:25: warning: 'struct platform_device' declared inside parameter list
> include/linux/mtd/physmap.h:25: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/mtd/physmap.h:26: warning: 'struct platform_device' declared inside parameter list
> include/linux/mtd/physmap.h:27: warning: 'struct platform_device' declared inside parameter list
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

David, it looks like Russel did not merge this patch and people
complain. Could you please merge it?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

