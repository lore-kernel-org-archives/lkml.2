Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0JVJNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:13:48 -0400
Received: from [85.183.114.52] ([85.183.114.52]:53162 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754035Ab0JVJNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:13:46 -0400
X-Greylist: delayed 2037 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 05:13:46 EDT
Date: Fri, 22 Oct 2010 10:39:52 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Joe Perches <joe@perches.com>, Joern Engel <joern@lazybastard.org>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/mtd/devices/phram.c: Use KBUILD_MODNAME
Message-ID: <20101022083952.GJ16783@logfs.org>
References: <1287596362.1813.205.camel@Joe-Laptop> <1287657452.2932.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287657452.2932.15.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 October 2010 13:37:32 +0300, Artem Bityutskiy wrote:
> On Wed, 2010-10-20 at 10:39 -0700, Joe Perches wrote:
> > Use the more standard #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > No change in output strings.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Pushed to l2-mtd-2.6.git, thanks.

Fine with me. (aka Acked-By:)

Jörn

-- 
"Error protection by error detection and correction."
-- from a university class
