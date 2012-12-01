Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2LAAcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:32:06 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49613 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020Ab2LAAcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:32:04 -0500
X-Sasl-enc: 5sm9zgguWVS8eg6MAkLIY3ra7byyKlfDTPLk8qJkdU32 1354321922
Date: Fri, 30 Nov 2012 16:32:01 -0800
From: Greg KH <greg@kroah.com>
To: Anthony Foiani <tkil@scrye.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] v3.0.x: mtd: check partition count not partition
 array pointer
Message-ID: <20121201003201.GA18885@kroah.com>
References: <gpq3oh9on.fsf@dworkin.scrye.com>
 <20121129213838.GA20660@kroah.com>
 <gvccm1v5b.fsf@dworkin.scrye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gvccm1v5b.fsf@dworkin.scrye.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 05:19:28PM -0700, Anthony Foiani wrote:
> Greg KH <greg@kroah.com> writes:
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> 
> My checklist against stable_kernel_rules.txt is below.
> 
> I could only find two reasons why you are saying this is incorrect:
> 
>   1. There is no matching upstream commit; or

This is an obvious one, it needs to be upstream first.

Or if not, a whole lot of explaination saying that you know it isn't,
and why it isn't, and why it isn't applicable there, including agreement
from the subsystem maintainers saying that they agree with you.

thanks,

greg k-h
