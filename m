Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab2JWJn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:43:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37802 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932435Ab2JWJn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:43:28 -0400
Date: Tue, 23 Oct 2012 10:43:25 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 1/2] firmware: Convert firmware path setup from an
	array to a list
Message-ID: <20121023094325.GA6339@opensource.wolfsonmicro.com>
References: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com> <1349866585-24883-2-git-send-email-dp@opensource.wolfsonmicro.com> <20121022154202.GA16115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022154202.GA16115@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 08:42:02AM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 10, 2012 at 11:56:24AM +0100, Dimitris Papastamos wrote:
> > In preparation to support dynamic listing/updating of firmware
> > paths via procfs, this patch converts the firmware path configuration
> > from an array to a list.
> > 
> > Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> 
> This series doesn't apply anymore due to changes in this code from Ming.
> Can you redo it against the my staging-linus branch, or the next
> linux-next release, so that I can apply them?
> 
> thanks,
> 
> greg k-h

Hi, I've not had time to implement this properly as discussed in the thread.
Should the current changes on top of Ming's changes nevertheless?

Thanks,
Dimitris
