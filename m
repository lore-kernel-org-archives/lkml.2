Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1KMQBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 11:01:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab1KMQBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 11:01:20 -0500
Date: Sun, 13 Nov 2011 07:58:34 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [patch 0/8] Samsung Laptop driver patches - resend
Message-ID: <20111113155834.GA7838@suse.de>
References: <20110920161743.GA32737@kroah.com>
 <CAHR064gzgKtLSNQ-NuoKWW9-Nv_S0myOusQT+-CxVVeyO5fMKA@mail.gmail.com>
 <20111107181209.GB5474@suse.de>
 <CAHR064jx4jWdLHRaKECEz-1Wauhm1xR+pGNLXsPPn7jYKJ81Uw@mail.gmail.com>
 <CAHR064i+PNSae_3+PnMtmkhpRw=+5qEAdUu_EzOiBfVzF_gfhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064i+PNSae_3+PnMtmkhpRw=+5qEAdUu_EzOiBfVzF_gfhA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 10:52:29AM +0100, Corentin Chary wrote:
> However, I have a quick question: what does "wireless button" control
> exactly ? Because my laptop (SwSmi@ one), seems to have a totally
> different command to control rfkill (both for bluetooth and wlan). My
> guess is that command do the same thing that happens when you press
> the Fn+F12 key, but if it's really that I'd prefer use the "true"
> rfkill interface with differencied control for bluetooth and wlan.

I think it controlled the wireless on/off on some machines, others might
be different.  And it should be using rfkill, right?

greg k-h
