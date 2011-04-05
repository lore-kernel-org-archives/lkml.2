Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab1DEHga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:36:30 -0400
Received: from kroah.org ([198.145.64.141]:59573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1DEHg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:36:28 -0400
Date: Mon, 4 Apr 2011 22:08:48 -0700
From: Greg KH <greg@kroah.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hv: Reduce indention in vmbus_on_event
Message-ID: <20110405050848.GA8330@kroah.com>
References: <20110322210207.GA17724@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322210207.GA17724@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:02:07PM +0100, Olaf Hering wrote:
> Reduce indention in vmbus_on_event() by converting two
> if (var) to if (!var)
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

This, and I think your other ones in this series, no longer applies due
to changes made by others to this driver.

Can you resync off of the next linux-next release and resend the
patches?  I'd also like to get an ack or tested-by or something from
Hank and the other developers of these drivers before accepting them.

thanks,

greg k-h
