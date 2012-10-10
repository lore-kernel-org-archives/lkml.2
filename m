Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2JJNp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:45:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45477 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065Ab2JJNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:45:55 -0400
Date: Wed, 10 Oct 2012 14:45:52 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 2/2] firmware: Add /proc/fw_path entry to list the
	firmware paths
Message-ID: <20121010134552.GA21381@opensource.wolfsonmicro.com>
References: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com> <1349866585-24883-3-git-send-email-dp@opensource.wolfsonmicro.com> <20121010133655.GA11678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010133655.GA11678@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:36:55PM +0900, Greg Kroah-Hartman wrote:
> On Wed, Oct 10, 2012 at 11:56:25AM +0100, Dimitris Papastamos wrote:
> > This patch provides the aforementioned procfs file that lists
> > the default firmware paths that are used during firmware lookup.
> > 
> > The file contains a white space separated list of paths.
> > 
> > There will be another patch on top of this that adds the functionality
> > to modify the paths at runtime.
> > 
> > Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> 
> What about /proc/sys/kernel/firmware_path instead?  Isn't that a better
> place for this?
> 
> greg k-h

Yes that makes more sense to me.

Thanks,
Dimitris
