Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0HKPbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:31:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:44434 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0HKPbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:31:41 -0400
Date: Wed, 11 Aug 2010 08:21:55 -0700
From: Greg KH <gregkh@suse.de>
To: Davidlohr Bueso <dave@gnu.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org
Subject: Re: [PATCH] kernel/ksysfs: use snprintf for sysfs show
Message-ID: <20100811152155.GC9180@suse.de>
References: <1281534250.2067.14.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281534250.2067.14.camel@cowboy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 09:44:10AM -0400, Davidlohr Bueso wrote:
> Use snprintf(buf, PAGE_SIZE, ...) instead of sprintf for sysfs show
> methods.  This is suggested in Documentation/filesystems/sysfs.txt

As Al pointed out, none of these will ever overflow so it makes no sense
to change them.

thanks,

greg k-h
