Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992608Ab2JYSsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:48:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37749 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992563Ab2JYSsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:48:37 -0400
Date: Thu, 25 Oct 2012 11:48:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] firmware: Add /proc/firmware_path entry to list
 the firmware paths
Message-ID: <20121025184833.GA22114@kroah.com>
References: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1350996776-17864-3-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350996776-17864-3-git-send-email-dp@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:52:55PM +0100, Dimitris Papastamos wrote:
> This patch provides the aforementioned procfs file that lists
> the default firmware paths that are used during firmware lookup.
> 
> The file contains a white space separated list of paths.

Paths can have whitespaces :(

How about using the "universal" path seperator of ':' that shells are
used to using?  Yeah, it gets messy if you have a ':' in a path, but
from what I can tell, only the openSUSE build system does looney things
like that.

> There will be another patch on top of this that adds the functionality
> to modify the paths at runtime.

Did I miss that patch somewhere?

thanks,

greg k-h
