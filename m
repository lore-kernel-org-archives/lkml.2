Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1CKQI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:08:58 -0500
Received: from kroah.org ([198.145.64.141]:45358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab1CKQI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:08:57 -0500
Date: Fri, 11 Mar 2011 08:08:15 -0800
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311160815.GA7426@kroah.com>
References: <4D79F068.2080009@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D79F068.2080009@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:50:32AM +0000, Andy Green wrote:
> The particular use that suggested this is on Panda, it would be
> ideal to be able to set a flag in the usb device's platform data
> that forces it to be named eth%d since it's a hardwired asset on the
> board with an RJ45 socket.

If you _really_ need to name your network devices in a specific order,
then use the userspace tools we already have to do this.  That is what
they were created for, why ignore them?

thanks,

greg k-h
