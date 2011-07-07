Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1GGJ2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:28:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55247 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1GGJ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:28:09 -0400
Date: Thu, 7 Jul 2011 12:26:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Ravishankar <ravishankarkm32@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 5/5] Staging: comedi: fix warning issue in unioxx5.c
Message-ID: <20110707092653.GL18655@shale.localdomain>
References: <1310022039-25599-1-git-send-email-ravishankarkm32@gmail.com>
 <CAHj3AVkz11sxubOyoJBwh6aa+SO1TGh3rYCwPSr-SJ8V1fF4EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHj3AVkz11sxubOyoJBwh6aa+SO1TGh3rYCwPSr-SJ8V1fF4EQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 12:28:21PM +0400, Denis Kirjanov wrote:
> I wonder if this patch improves code readability
> 

I would like for the line width warning to be removed or that we
would allow longer lines.  I don't see a lot of value in it and it's
all to common to see code that does stuff like this:
							foo->
							  bar_fw_baz
							    [10 + 1
							       + 1]
							         = x;

But I've given up hoping that it will change.  People are going to
keep submitting these patches until we merge one of them so we might
as well merge the half way decent one that gets submitted.

regards,
dan carpenter


