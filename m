Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0J3IjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 04:39:22 -0400
Received: from static.200.77.63.178.clients.your-server.de ([178.63.77.200]:43024
	"EHLO Debian-50-lenny-64-minimal" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752165Ab0J3IjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 04:39:19 -0400
Date: Sat, 30 Oct 2010 10:39:17 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 4/6] hwmon: Change mail address of Hans J.
 Koch
Message-ID: <20101030083917.GA2487@local>
References: <20101029221231.GA4331@local>
 <20101029223223.GE4331@local>
 <20101030102136.6a6a3035@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101030102136.6a6a3035@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 10:21:36AM +0200, Jean Delvare wrote:
> > @@ -2629,7 +2629,7 @@ static void __exit lm93_exit(void)
> >  }
> >  
> >  MODULE_AUTHOR("Mark M. Hoffman <mhoffman@lightlink.com>, "
> > -		"Hans J. Koch <hjk@linutronix.de");
> > +		"Hans J. Koch <hjk@hansjkoch.de");
> 
> Probably the right time to add the missing ">". I'll do it, consider
> this patch applied.

Ah, right. That's what happens when I just run a script over the whole tree...
Thanks for fixing it,

Hans

