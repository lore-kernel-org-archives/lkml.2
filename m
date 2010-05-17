Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0EQION (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:14:13 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51501 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0EQIOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:14:10 -0400
Date: Mon, 17 May 2010 10:14:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       lm-sensors@lm-sensors.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] Simple fan question
Message-ID: <20100517101407.193b93f2@hyperion.delvare>
In-Reply-To: <20100517074621.GA14520@ucw.cz>
References: <1272518506.24542.163.camel@pasglop>
	<20100429105740.6e3b7716@hyperion.delvare>
	<1272581806.24542.185.camel@pasglop>
	<20100517074621.GA14520@ucw.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Mon, 17 May 2010 09:46:21 +0200, Pavel Machek wrote:
> Hi!
> 
> > Right.
> > 
> > Now, maybe the best option is to have instead:
> > 
> > 	fan[1-*]_discrete_value
> > 		Discrete value
> >                 RW
> > 
> > 	fan[1-*]_supported values
> >                 List of supported discrete values
> >                 RO
> 
> Hmm, for 100 different values, that will get ugly. What about simple
> fan_max file with values 0..fan_max being valid?

If you have 100 different values, you can map them to the standard
0..255 range of pwm[1-*] files.

> IIRC thinkpads have 8-or-so possible discrete cases...

Correct. And even these would map nicely to the 0..255 range IMHO.

-- 
Jean Delvare
