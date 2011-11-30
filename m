Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab1K3RXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:23:50 -0500
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:40217 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755565Ab1K3RXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:23:47 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Nov 2011 12:23:46 EST
X-AntiVirus: PTMail-AV 0.4-0.97.0
X-Scan-Status: AV clean (0.02330 seconds);
 AS clean (2.01595 seconds);
X-Antivirus-bastov-Mail-From: sergio@serjux.com via serjux.com
X-Antivirus-bastov: 1.25-st-qms (Clear:RC:0(194.65.5.235):SA:0(0.3/5.0):. Processed in 1.395371 secs Process 29977)
Message-ID: <1322673417.31541.1.camel@segulix>
Subject: Re: linux-next: Tree for Nov 29 (drm)
From: =?ISO-8859-1?Q?S=E9rgio?= Basto <sergio@serjux.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Date: Wed, 30 Nov 2011 17:16:57 +0000
In-Reply-To: <4ED5417C.1030908@xenotime.net>
References: <20111129152040.3040fe9780886ee0e066a131@canb.auug.org.au>
	 <4ED5417C.1030908@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy, not dri-devel@lists.sourceforge.net, anymore 
now is dri-devel@lists.freedesktop.org

On Tue, 2011-11-29 at 12:33 -0800, Randy Dunlap wrote: 
> On 11/28/2011 08:20 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20111128:
> > 
> > The drm tree lost its build failure but gained another for which I
> > applied a patch.
> 
> 
> ERROR: "drm_helper_get_fb_bpp_depth" [drivers/gpu/drm/vmwgfx/vmwgfx.ko] undefined!
> 
> Full x86_64 randconfig file is attached.
> 
> ------------------------------------------------------------------------------
> All the data continuously generated in your IT infrastructure 
> contains a definitive record of customers, application performance, 
> security threats, fraudulent activity, and more. Splunk takes this 
> data and makes sense of it. IT sense. And common sense.
> http://p.sf.net/sfu/splunk-novd2d
> -- _______________________________________________ Dri-devel mailing list Dri-devel@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/dri-devel

-- 
Sérgio M. B.

