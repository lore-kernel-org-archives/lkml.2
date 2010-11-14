Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0KNRze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 12:55:34 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46176 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab0KNRzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 12:55:32 -0500
Date: Sun, 14 Nov 2010 18:54:51 +0100
From: Borislav Petkov <bp@amd64.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
        edac-devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH -next] edac: use BIT_64() to eliminate warnings
Message-ID: <20101114175451.GA13977@aftab>
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
 <20101113084426.b26f1d88.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113084426.b26f1d88.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 11:44:26AM -0500, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Building for X86_32 produces shift count warnings, so use
> BIT_64() to eliminate the warnings.
> 
> drivers/edac/mce_amd.c:778: warning: left shift count >= width of type
> drivers/edac/mce_amd.c:778: warning: left shift count >= width of type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Cc: bluesmoke-devel@lists.sourceforge.net

Thanks, applied.

BTW, Doug, we still carry the bluesmoke-devel ML as edac mailing list
in MAINTAINERS althouth there's a new linux-edac@vger... which got
proposed recently. I think we should use that new one and deprecate the
sourceforge list since the new one is not moderated for subsribers and
thus more open.

Thoughts?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
