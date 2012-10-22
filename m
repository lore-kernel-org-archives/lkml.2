Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2JVPmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:42:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38968 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab2JVPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:42:06 -0400
Date: Mon, 22 Oct 2012 08:42:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 1/2] firmware: Convert firmware path setup from an array
 to a list
Message-ID: <20121022154202.GA16115@kroah.com>
References: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1349866585-24883-2-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349866585-24883-2-git-send-email-dp@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 11:56:24AM +0100, Dimitris Papastamos wrote:
> In preparation to support dynamic listing/updating of firmware
> paths via procfs, this patch converts the firmware path configuration
> from an array to a list.
> 
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

This series doesn't apply anymore due to changes in this code from Ming.
Can you redo it against the my staging-linus branch, or the next
linux-next release, so that I can apply them?

thanks,

greg k-h
