Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2LMTjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:39:00 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48872 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2LMTi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:38:59 -0500
Message-ID: <50CA2ED0.8050501@gmail.com>
Date: Thu, 13 Dec 2012 17:38:56 -0200
From: Marco Biscaro <marcobiscaro2112@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Benoit Touchette <draekko.dev@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, trivial@kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] USB: adds support for Novatek wireless mouse to usbhid
References: <CAKPZWXc55MWN3ajpvf0vLXP9KebFo17bGAmD8X=mavxyWJui1w@mail.gmail.com> <20121213015025.GA10991@kroah.com>
In-Reply-To: <20121213015025.GA10991@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 12-12-2012 23:50, Greg KH escreveu:
> Please use the scripts/get_maintainer.pl tool to send this patch to the
> correct people and mailing list.
>
> Also, your patch is line-wrapped, and can't be applied, you need to look
> into fixing your email client to not do this if you wish to get patches
> accepted.
>
> greg k-h

This patch was already proposed[1] and Jiri Kosina (which is CC'd) said 
"It's queued in my tree, but didn't justify pull request to Linus just 
because of this, so currently it's scheduled for 3.8."

[1] http://permalink.gmane.org/gmane.linux.usb.general/75252
