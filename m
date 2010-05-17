Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0EQHqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:46:36 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51603 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754339Ab0EQHqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:46:35 -0400
Date: Mon, 17 May 2010 09:46:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] Simple fan question
Message-ID: <20100517074621.GA14520@ucw.cz>
References: <1272518506.24542.163.camel@pasglop>
 <20100429105740.6e3b7716@hyperion.delvare>
 <1272581806.24542.185.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272581806.24542.185.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Right.
> 
> Now, maybe the best option is to have instead:
> 
> 	fan[1-*]_discrete_value
> 		Discrete value
>                 RW
> 
> 	fan[1-*]_supported values
>                 List of supported discrete values
>                 RO

Hmm, for 100 different values, that will get ugly. What about simple
fan_max file with values 0..fan_max being valid?

IIRC thinkpads have 8-or-so possible discrete cases...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
