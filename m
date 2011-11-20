Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1KTAoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 19:44:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1KTAoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 19:44:17 -0500
Date: Sat, 19 Nov 2011 16:43:17 -0800
From: Greg KH <gregkh@suse.de>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/26] 3.1.2-stable review
Message-ID: <20111120004317.GA31740@suse.de>
References: <20111119000336.GA8452@kroah.com>
 <4EC80A2F.7030800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC80A2F.7030800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 02:57:35PM -0500, Woody Suwalski wrote:
> Greg KH wrote:
> Please include also
> 
> Takashi Iwai (1):
>       drm/i915: Fix inconsistent backlight level during disabled
> 
> 
> which is fixing a black-screen regression from 3.0 kernel.

What is the git commit id for this patch?  And you do know you can send
this information to the stable@vger.kernel.org mailing list some time
other than the announcement for the -rc releases :)

thanks,

greg k-h
