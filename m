Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1AKNAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:00:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:35148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1AKNA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:00:29 -0500
Date: Tue, 11 Jan 2011 14:00:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "James T. Dickson" <james.dickson@jtdata.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce 'notimeout' blacklist for Dell Vostro
 V13 (was Re: Synaptics touchpad on Dell Vostro V13)
In-Reply-To: <20110107172847.GA28785@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1101111359410.26685@pobox.suse.cz>
References: <8583070.26.1294325869588.JavaMail.root@butch.jtdata.net> <alpine.LNX.2.00.1101071105350.26685@pobox.suse.cz> <20110107172847.GA28785@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Dmitry Torokhov wrote:

> > Dmitry, what is your current plan with the notimeout thing for V13, 
> > please? Still .38 material?
> 
> Yeah, especially given that not all V13 seem to suffer from
> suspend/resume issue.

Hi Dmitry,

I can see that you applied the patch, thanks.

It seems to be in 'next' branch -- does that mean that it will not go in 
this merge window still?

Thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
