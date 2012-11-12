Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2KLHyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:54:37 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40904 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750856Ab2KLHyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:54:36 -0500
Message-ID: <1352706875.2015.10.camel@joe-AO722>
Subject: Re: [PATCH 0/8] Fix coding style in sdhci.c
From: Joe Perches <joe@perches.com>
To: Chris Ball <cjb@laptop.org>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, patches@linaro.org
Date: Sun, 11 Nov 2012 23:54:35 -0800
In-Reply-To: <87a9unnvl1.fsf@octavius.laptop.org>
References: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org>
	 <50A05DE9.8070907@samsung.com> <50A07D30.4030705@linaro.org>
	 <87a9unnvl1.fsf@octavius.laptop.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 02:12 -0500, Chris Ball wrote:
> Hi,
> 
> On Sun, Nov 11 2012, Tushar Behera wrote:
> > Yes, I can do that. I did split it specifically so that we could drop
> > any patches if required.
> >
> > I will wait for a word from Chris regarding what he prefers.
> 
> I would want to merge one patch, but I'm afraid I don't generally want
> to merge changes like these.  sdhci.c is one of the most modified files
> in drivers/mmc, so a change like this can create merge conflicts that
> require many people to update their work, and that's not worth it.

I think brace style isn't important enough too.

I suggested this awhile ago, but it went nowhere.

https://lkml.org/lkml/2011/8/11/425


