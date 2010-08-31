Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0HaTBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:01:32 -0400
Received: from kroah.org ([198.145.64.141]:34409 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab0HaTBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:01:31 -0400
Date: Tue, 31 Aug 2010 11:49:09 -0700
From: Greg KH <greg@kroah.com>
To: Maurice Dawson <mauricedawson2699@gmail.com>
Cc: gregkh@suse.de, rich.folsom@gmail.com, mithlesh@linsyssoft.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: fix over 80 characters coding
 style issue in adl_pci9111.c
Message-ID: <20100831184909.GA929@kroah.com>
References: <1281020488-2696-1-git-send-email-mauricedawson2699@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281020488-2696-1-git-send-email-mauricedawson2699@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 04:01:28PM +0100, Maurice Dawson wrote:
> This is a patch to the adl_pci9111.c file that fixes up most over 80 characters warnings found by the checkpatch.pl tool. The lines that are still over 80 characters are either strings or, by changing them their readability would be unacceptably reduced.
> 
> Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
> ---

This patch no longer applies to the linux-next tree.  Care to redo it so
that I can apply it?

thanks,

greg k-h
