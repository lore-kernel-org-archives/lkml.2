Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2KGMKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:10:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2KGMKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:10:48 -0500
Date: Wed, 7 Nov 2012 13:10:37 +0100
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH] pwm-backlight: Add support for active low PWM
 backlights
Message-ID: <20121107131037.3bd52a96@avionic-0020.adnet.avionic-design.de>
In-Reply-To: <20121106064405.GB14863@avionic-0098.mockup.avionic-design.de>
References: <1352130541-16819-1-git-send-email-alban.bedel@avionic-design.de>
	<20121106064405.GB14863@avionic-0098.mockup.avionic-design.de>
Organization: Avionic Design
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:IO+h3d2NXjxzysVMR2mf/Sa9A2x06nMS0GA6aB/i5Cm
 QGtcGMlunqdzoNj66yXylQ7EUahRJLgTVCzDsrzGU25xZu5e1F
 A+UEFVSlW9gBdemQ9if/rVv/oADuxXd1dsRdJGvIXucCm1sprW
 m3vQPXQfr42okK4Gt+Khr0+kA7ng7ih0hqkVXrpJcXE25bSFcJ
 tFJtwPdH6LgPwWcK84l/RMTR0OolDi4emPeit3chvxQ9EARvwc
 jQMt4j0rn1q02+TYIrn9oPfTlTmuKMjWMzBLg/Ga9EofRFZq18
 jhwZuocDRxlMH9VccJecbmEPbEjOGWux2pvEZmtU3/jQYLnokh
 mf3qsFfRRcYUKv0//gBWJd9zlcK3lyGHzTU9S/bmBWUPklnBva
 +o6fx6zsRQG6vjkUdUTJBFG2Y8jWZzUkF4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012 07:44:06 +0100
Thierry Reding <thierry.reding@avionic-design.de> wrote:

> > --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > @@ -14,6 +14,7 @@ Required properties:
> >  Optional properties:
> >    - pwm-names: a list of names for the PWM devices specified in the
> >                 "pwms" property (see PWM binding[0])
> > +  - active-low: boolean indicating that the backlight use active low logic
> 
> Couldn't you use the brightness-levels property to achieve the same
> effect?

Not in the current state as the curve currently hardcode the fact the
first element have 0% duty and the last 100%. But relaxing this
limitation is probably better as it would also allow clamping the curve
like the lth_brightness parameter do when no curve is used.

I'll send a new patch implementing this soon.

Alban
