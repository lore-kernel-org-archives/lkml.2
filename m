Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab2DFX2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:28:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2DFX2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:28:37 -0400
Date: Fri, 6 Apr 2012 16:28:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuahkhan@gmail.com
Cc: Geon Si Jeong <gshark.jeong@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Daniel Jeong <daniel.jeong@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] leds: Add LED driver for lm3556 chip
Message-Id: <20120406162835.d6fc1cac.akpm@linux-foundation.org>
In-Reply-To: <1333251443.5466.3.camel@lorien2>
References: <1333089508-8501-1-git-send-email-gshark.jeong@gmail.com>
	<1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
	<20120330114122.be769e8a.akpm@linux-foundation.org>
	<1333251443.5466.3.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2012 21:37:23 -0600
Shuah Khan <shuahkhan@gmail.com> wrote:

> > +	ret = kstrtoul(buf, 10, &state);
> > +	if (ret)
> > +		goto out;
> >  	if (isspace(*after))
> >  		count++;
> 
> after is used without initialization. Please note that simple_strtoul()
> initializes after. Don't think this will work.

I didn't try very hard ;)

I think I'll drop the whole patch.  According to my notes,

- Wolfram's comments should be addressed
- Move the header file out of include/linux/
- Consider using the regmap API
