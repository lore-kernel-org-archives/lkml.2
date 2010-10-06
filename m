Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab0JFUru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:47:50 -0400
Received: from kroah.org ([198.145.64.141]:46422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931Ab0JFUrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:47:48 -0400
Date: Wed, 6 Oct 2010 13:21:43 -0700
From: Greg KH <greg@kroah.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
Message-ID: <20101006202143.GE26397@kroah.com>
References: <1286302800-2715-1-git-send-email-rahul.ruikar@gmail.com>
 <4CAB79C4.3030208@ru.mvista.com>
 <AANLkTinBBUQuEnWzASb5daiE+C3w+Rs8kLdgzK7XAyne@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinBBUQuEnWzASb5daiE+C3w+Rs8kLdgzK7XAyne@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 08:04:23AM +0530, Rahul Ruikar wrote:
> updated patch with following changes.
> - variable name changed
> - comment updated.
> 
> Please find it attached here.

Please resend it, not attached in base64 format so that I can apply it
properly.

thanks,

greg k-h
