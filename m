Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2CMXcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:32:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41801 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2CMXcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:32:21 -0400
Date: Tue, 13 Mar 2012 16:32:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120313233217.GB31106@kroah.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 08:40:32AM -0300, Mauro Carvalho Chehab wrote:
> Prepare the internal structures to represent the memory properties per dimm, 
> instead of per csrow. 
> 
> This is needed for modern controllers with more than 2 channels, as the memories 
> at the same slot number but on different channels (or channel pairs) may be 
> different.
> 
> Mauro Carvalho Chehab (6):
>   edac: Create a dimm struct and move the labels into it
>   edac: Add per dimm's sysfs nodes

You need Documentation/ABI entries for these new sysfs files.

thanks,

greg k-h
