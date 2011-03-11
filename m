Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1CKWd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:33:29 -0500
Received: from kroah.org ([198.145.64.141]:49638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab1CKWdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:33:25 -0500
Date: Fri, 11 Mar 2011 14:31:19 -0800
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next 2/6] staging: bcm: fix memory leaks
Message-ID: <20110311223119.GA31049@kroah.com>
References: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
 <1299724988-25351-2-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299724988-25351-2-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 05:43:04AM +0300, Alexander Beregalov wrote:
> Free resources before exit.

Next time, test your patches before sending them out.  This one breaks
the build so I've dropped all of the patches in this series.  Please fix
them, test them (by at the very _least_ building them) and then resend
them.

thanks,

greg k-h
