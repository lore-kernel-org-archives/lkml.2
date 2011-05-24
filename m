Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1EXF6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:58:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49851 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1EXF6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k4piI0vB/1Sr4PPpZcjn28Jr0+0ezyDYF1Va5nfZ9i7qlkl9KBZiXWIJngv9epcLaN
         K0e/fOEVS2tC0/LotwsyXrdBxpRQ9Bg8/hfOSTR55WOpu4uXvzn7lyHPM6bEsoLGZZHk
         RKsAtLum8/av1MACOMkip96efPNzbHbExdh+8=
Subject: Re: [PATCH -next] mtd: fix physmap.h warnings
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mtd@lists.infradead.org,
        linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
In-Reply-To: <20110523113709.4357b4ba.randy.dunlap@oracle.com>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	 <20110523113709.4357b4ba.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 08:53:51 +0300
Message-ID: <1306216431.2785.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 11:37 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build warnings in physmap.h:
> 
> include/linux/mtd/physmap.h:25: warning: 'struct platform_device' declared inside parameter list
> include/linux/mtd/physmap.h:25: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/mtd/physmap.h:26: warning: 'struct platform_device' declared inside parameter list
> include/linux/mtd/physmap.h:27: warning: 'struct platform_device' declared inside parameter list
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Oh, this was missed during review.  This was introduced in
b7281ca2a4b00044c60c25059f467d05772cdbe3 which is going in via Russel's
tree, so I guess Russel could pick up your patch.

CCed relevant people.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

