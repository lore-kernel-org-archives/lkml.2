Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1AEGLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 01:11:07 -0500
Received: from freeflow.nu ([178.79.134.28]:58746 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab1AEGLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 01:11:06 -0500
Subject: Re: [PATCH 1/6] Staging: w35und: Merge wbhal_f.h to wbhal_s.h
From: Pekka Enberg <penberg@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20110102090231.GF32469@atrey.karlin.mff.cuni.cz>
References: <1291454177-5102-1-git-send-email-penberg@kernel.org>
	 <20101207001253.GA20030@kroah.com> <4CFDD4D8.10403@kernel.org>
	 <20110102090231.GF32469@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 05 Jan 2011 08:11:02 +0200
Message-ID: <1294207862.5248.37.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-02 at 10:02 +0100, Pavel Machek wrote:
> Hi!
> 
> >> This patch doesn't apply at all, what was it made against?
> >
> > They're actually patches that predate the ones you merged recently from  
> > me. I just pulled your tree to mine and did "git format-patch" without  
> > thinking about it too much.
> >
> >> Care to refresh this whole series so it can be applied?
> >
> > Sure, I can do that.
> 
> Thanks... and ACK for the whole series.

Interesting enough, Greg had already merged them before I resent them:

http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=commitdiff;h=72ca8819f7f4ac4ddf82ab72ee614075821a3d00

I guess either me or Git was confused to think they hadn't been merged.
It also explains why the patches didn't apply. ;-)

