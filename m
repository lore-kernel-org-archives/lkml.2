Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2KGOhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:37:48 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60580 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2KGOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:37:47 -0500
Date: Wed, 7 Nov 2012 15:38:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 3.7-rc3+git hard lockup on CPU after
 inserting/removing USB stick
Message-ID: <20121107143800.GA14146@kroah.com>
References: <201211071501.38288.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211071501.38288.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 03:01:38PM +0100, Martin Steigerwald wrote:
> Hi!
> 
> I had this with something in between 3.7-rc3 und 3.7-rc4 after inserting
> and removing an USB stick. This example is with a kernel + f2fs patches v3,
> but I had this with 3.7-rc3 as well.

Ok, so it's not a new thing introduced in 3.7-rc4 (which is good, as
there wasn't any USB patches added between -rc3 and -rc4.)

Does it also happen on -rc2?  Anything older?  Can you run 'git bisect'
to try to track it down?

thanks,

greg k-h
