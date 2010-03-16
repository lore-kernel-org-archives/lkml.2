Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966589Ab0CPR5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:57:10 -0400
Received: from kroah.org ([198.145.64.141]:54248 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966173Ab0CPR5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:57:08 -0400
Date: Tue, 16 Mar 2010 10:54:23 -0700
From: Greg KH <greg@kroah.com>
To: NeilBrown <neilb@suse.de>
Cc: Greg KH <gregkh@suse.de>, Mimi Zohar <zohar@us.ibm.com>,
       "Serge E . Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kref: remove kref_set
Message-ID: <20100316175423.GA23303@kroah.com>
References: <19359.1467.612457.401272@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19359.1467.612457.401272@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 03:14:51PM +1100, NeilBrown wrote:
> 
> 
> Of the three uses of kref_set in the kernel:
> 
>  One really should be kref_put as the code is letting go of a
>     reference,
>  Two really should be kref_init because the kref is being
>     initialised.
> 
> This suggests that making kref_set available encourages bad code.
> So fix the three uses and remove kref_set completely.

Yeah!

I really didn't like kref_set at all anyway, and I thought that someone
"required it" which is why it was added.  Oh well, I'm glad it is now
gone, thanks so much for this patch.

greg k-h
