Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab0KPUHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:07:52 -0500
Received: from kroah.org ([198.145.64.141]:48874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758461Ab0KPUHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:07:51 -0500
Date: Tue, 16 Nov 2010 11:43:44 -0800
From: Greg KH <greg@kroah.com>
To: Damian Varayud <davarayud@gmail.com>
Cc: gregkh@suse.de, arun.thomas@gmail.com, ezemed7@gmail.com, tj@kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix coding style issue in pcmuio.c
Message-ID: <20101116194344.GA29291@kroah.com>
References: <1289485692-1527-1-git-send-email-user@netbu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289485692-1527-1-git-send-email-user@netbu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 11:28:12AM -0300, Damian Varayud wrote:
> This is a patch to the pcmuio.c file that fixes up braces, overlines and
> printk warnings found by the checkpatch.pl tool
> 
> Signed-off-by: Ezequiel Medina <ezemed7@gmail.com>

I'm confused here.  The patch was sent by "Damian Varayud
<davarayud@gmail.com>", yet the signed-off-by has a different name.

Please fix this up and resend all 3 of these patches.

thanks,

greg k-h
