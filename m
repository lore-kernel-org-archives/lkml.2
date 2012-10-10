Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab2JJNhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:37:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63729 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2JJNhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:37:00 -0400
Date: Wed, 10 Oct 2012 22:36:55 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 2/2] firmware: Add /proc/fw_path entry to list the
 firmware paths
Message-ID: <20121010133655.GA11678@kroah.com>
References: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1349866585-24883-3-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349866585-24883-3-git-send-email-dp@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 11:56:25AM +0100, Dimitris Papastamos wrote:
> This patch provides the aforementioned procfs file that lists
> the default firmware paths that are used during firmware lookup.
> 
> The file contains a white space separated list of paths.
> 
> There will be another patch on top of this that adds the functionality
> to modify the paths at runtime.
> 
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

What about /proc/sys/kernel/firmware_path instead?  Isn't that a better
place for this?

greg k-h
