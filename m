Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab0KVVcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:32:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:58986 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab0KVVcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:32:20 -0500
Date: Mon, 22 Nov 2010 13:31:22 -0800
From: Greg KH <gregkh@suse.de>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for November 22
Message-ID: <20101122213122.GA2881@suse.de>
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>
 <AANLkTi=QeU_vb6+XRei0pqz7GSfp2E4TC3oTJYy9adv4@mail.gmail.com>
 <20101122194643.GB21985@suse.de>
 <400C43189542CE41BC0A5B252FC90136952F05944A@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <400C43189542CE41BC0A5B252FC90136952F05944A@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 12:08:28PM -0800, Arend Van Spriel wrote:
> Hi Greg, Stephen,
> 
> The file wl_iw.c declare a struct semaphore variable and uses
> semaphore function, but there is no explicit inclusion of
> <linux/semaphore.h>. I hit this problem last week when trying a
> minimal kernel configuration for my development system. Normally we
> build and test against kernel configuration similar to Ubuntu
> configuration and we got the semaphore definitions for free. Expect a
> patch soon.

Ok, sounds good.

greg k-h
