Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1CIVlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:41:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab1CIVlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:41:16 -0500
Date: Wed, 9 Mar 2011 13:40:56 -0800
From: Greg KH <gregkh@suse.de>
To: Vinay Sawal <vinaysawal@gmail.com>
Cc: Belisko Marek <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Bcmnet: fixed checkpatch script issues
Message-ID: <20110309214056.GA28036@suse.de>
References: <1299703801-19378-1-git-send-email-vinaysawal@gmail.com>
 <AANLkTin6tvLb23pvew7H=1HGmQMsmcMujwZ=i017okku@mail.gmail.com>
 <AANLkTi==5jKHwTEhh1xE7_7-a7JHbaNWOdOKHFFdz0Wc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi==5jKHwTEhh1xE7_7-a7JHbaNWOdOKHFFdz0Wc@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 01:21:28PM -0800, Vinay Sawal wrote:
> You're correct. The script checkpatch didn't complain about the
> missing license header.

Where did you get that license header from?  Are you sure you were
allowed to license the code in that specific way?

> But since the license header was missing, I
> added it. I should have listed it in the patch comments.

No, you should have done it in a separate patch, if you do that.
Remember, one patch per "thing you do" is the rule.

> Isn't it a requirement to have the GPL license header in every file ?

No.

> If true, maybe the script can be enhanced to check for missing license
> header.

That's not true, the overall license of the kernel covers the license of
the file, if not explicitly stated.  And you were stating that the
license of this file is _different_ from the license of the kernel
overall, so you had better have the legal right to be doing that.  Do
you?

thanks,

greg k-h
