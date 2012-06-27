Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2F0NwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:52:20 -0400
Received: from gw1.transmode.se ([195.58.98.146]:55158 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab2F0NwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:52:18 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2012 09:52:18 EDT
MIME-Version: 1.0
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: <20120627133332.GA21572@pengutronix.de>
References: <20120627133332.GA21572@pengutronix.de>,
	<1340749442.3241.4046.camel@pc786-ubu.gnet.global.vpn>
Subject: Re: [PATCH] rtc: ds1307: Register offset moved to chip description
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Austin Boyle <Austin.Boyle@aviatnet.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Message-ID: <OFD3CD15E9.315EBD6D-ONC1257A2A.004B4768-C1257A2A.004B476C@transmode.se>
Date: Wed, 27 Jun 2012 15:42:14 +0200
X-Mailer: Lotus Domino Web Server Release 8.5.3FP1 March 07, 2012
X-MIMETrack: Serialize by Notes Server on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 27/06/2012 15:42:14,
	Serialize complete at 27/06/2012 15:42:14,
	Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 27/06/2012 15:42:14
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Wed, Jun 27, 2012 at 10:24:02AM +1200, Austin Boyle wrote:
> > rtc: ds1307: Register offset moved to chip description
> > 
> > From: Austin Boyle <Austin.Boyle@aviatnet.com>
> > 
> > Register offset is added to chip description instead of being hard-coded
> > into probe function.
> > 
> > Based on v3.5-rc4
> > 
> > Cc: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> > Cc: Alessandro Zummo <a.zummo@towertech.it>
> > Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
> 
> I would ack this patch immediately if it added another type using this
> feature. But only changing already working code doesn't seem necessary
> to me.
> 
> Regards,
> 
>     Wolfram
> 

That was my gut feeling too.

  Jocke