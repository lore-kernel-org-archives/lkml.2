Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0DLO3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 10:29:16 -0400
Received: from bamako.nerim.net ([62.4.17.28]:57216 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab0DLO3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 10:29:15 -0400
Date: Mon, 12 Apr 2010 16:29:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: Henrik Rydberg <rydberg@euromail.se>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Switch applesmc maintainer
Message-ID: <20100412162912.74515ddd@hyperion.delvare>
In-Reply-To: <4BC32050.7080806@boichat.ch>
References: <1271078868-3699-1-git-send-email-rydberg@euromail.se>
	<4BC32050.7080806@boichat.ch>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Apr 2010 21:29:52 +0800, Nicolas Boichat wrote:
> On 04/12/2010 09:27 PM, Henrik Rydberg wrote:
> > Nicolas has expressed a wish to be relieved from the maintenance
> > of applesmc, so we simply switch maintainer with this patch.
> 
> Thank you.
> 
> > Signed-off-by: Henrik Rydberg<rydberg@euromail.se>
> 
> Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
> 
> > ---
> >   MAINTAINERS |    4 ++--
> >   1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 7a9ccda..13c5688 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -485,8 +485,8 @@ S:	Maintained
> >   F:	drivers/input/mouse/bcm5974.c
> >
> >   APPLE SMC DRIVER
> > -M:	Nicolas Boichat<nicolas@boichat.ch>
> > -L:	mactel-linux-devel@lists.sourceforge.net
> > +M:	Henrik Rydberg<rydberg@euromail.se>
> > +L:	lm-sensors@lm-sensors.org
> >   S:	Maintained
> >   F:	drivers/hwmon/applesmc.c
> >

Patch applied, thanks Henrik for stepping in!

-- 
Jean Delvare
