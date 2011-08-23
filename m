Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1HWAoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:44:55 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54311 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab1HWAos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:44:48 -0400
X-Sasl-enc: ZTp5E2jY0lZx9drqxLA0sZYA+DxZJ5dwolxweTmpzUDg 1314060287
Date: Mon, 22 Aug 2011 17:43:18 -0700
From: Greg KH <greg@kroah.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, rpearson@systemfabricworks.com
Subject: Re: [PATCH] docs/driver-model: Document device.groups
Message-ID: <20110823004318.GA16599@kroah.com>
References: <CAO+b5-prWOxkXcKLM+KctdMjV9YhT8zyyBxjaR6ofnP944hGKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO+b5-prWOxkXcKLM+KctdMjV9YhT8zyyBxjaR6ofnP944hGKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 10:00:07PM +0200, Bart Van Assche wrote:
> Many drivers use device_create_file() where device.groups should be
> used instead. This patch documents that and also removes the comments
> about device classes since these should not be used in new code.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  Documentation/driver-model/device.txt |   78 +++++++++++++++------------------

This patch doesn't apply to 3.1-rc3, what kernel did you make it
against?

Care to resend so it can be applied?

thanks,

greg k-h
