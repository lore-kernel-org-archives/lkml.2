Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1CMRrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:47:40 -0400
Received: from kroah.org ([198.145.64.141]:48945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab1CMRrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:47:39 -0400
Date: Sun, 13 Mar 2011 10:48:11 -0700
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
Message-ID: <20110313174811.GA11504@kroah.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
 <201103131141.07380.rjw@sisk.pl>
 <4D7CB15A.6030203@linaro.org>
 <201103131353.54612.rjw@sisk.pl>
 <4D7CC4D0.90305@linaro.org>
 <20110313161528.GB10718@kroah.com>
 <4D7CFB3B.8060008@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7CFB3B.8060008@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 05:13:31PM +0000, Andy Green wrote:
> So when there's a bit more of Device Tree in evidence, are you going
> to accept Device-tree based patches in usbnet etc along these lines,
> or does that trigger the "do it in userspace" response, in which
> case we are both wasting each others' time continuing to discuss
> this at all?

As mentioned numerous times before, network naming stuff happens in
userspace, not in the kernel, so no matter what infrastructure is added,
insisting on naming the network device 'eth0' is not going to happen
within the kernel.  Please use the tools we have today to do this with
no kernel changes.

As for other changes, it all depends on what you need to accomplish,
right?  Those will be gladly reviewed on a case-by-case basis.

thanks,

greg k-h
