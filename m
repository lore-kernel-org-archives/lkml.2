Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab1B1EpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 23:45:09 -0500
Received: from kroah.org ([198.145.64.141]:57790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1B1EpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 23:45:07 -0500
Date: Sun, 27 Feb 2011 20:45:59 -0800
From: Greg KH <greg@kroah.com>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-embedded@vger.kernel.org
Subject: Re: [GIT PULL] Generic PWM Device API
Message-ID: <20110228044559.GA22678@kroah.com>
References: <AANLkTi=rxzrnt0QZQPJFRboSW_Fyt6zQ5S9KD4Lp=hnU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=rxzrnt0QZQPJFRboSW_Fyt6zQ5S9KD4Lp=hnU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 09:38:38PM -0600, Bill Gatliff wrote:
> Andrew, Linus:
> 
> 
> The git repository described in the following pull request implements
> a generic PWM device driver API.  This API is intended to eventually
> supercede the existing PWM device drivers, but during a migration
> period will coexist peacefully with them.
> 
> This code has been discussed at length on the linux-embedded mailing
> list.  Noteworthy threads include:
> 
> v6 (final) patches:
>    http://www.mail-archive.com/linux-embedded@vger.kernel.org/msg03291.html
> 
> v5 patches:
>    http://www.mail-archive.com/linux-embedded@vger.kernel.org/msg03279.html
> 
> v4 patches:
>    http://www.mail-archive.com/linux-embedded@vger.kernel.org/msg03263.html
> 
> 
> Thanks!

Isn't it a bit late in the -rc release cycle to pull this in now?

confused,

greg k-h
