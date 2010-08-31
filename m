Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0HaWii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:38:38 -0400
Received: from kroah.org ([198.145.64.141]:41270 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab0HaWih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:38:37 -0400
Date: Tue, 31 Aug 2010 15:30:43 -0700
From: Greg KH <greg@kroah.com>
To: Maurice Dawson <mauricedawson2699@gmail.com>
Cc: gregkh@suse.de, rich.folsom@gmail.com, mithlesh@linsyssoft.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: comedi: fix no space before tabs coding
 style issue in adl_pci9111.c
Message-ID: <20100831223043.GA32762@kroah.com>
References: <1281812178-2062-1-git-send-email-mauricedawson2699@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281812178-2062-1-git-send-email-mauricedawson2699@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 07:56:18PM +0100, Maurice Dawson wrote:
> This is a patch to the adl_pci9111.c file that fixes up the no space
> before tabs warning found by the checkpatch.pl tool

This patch doesn't apply, can you redo it against the linux-next tree to
verify that you have the latest version of the tree?

thanks,

greg k-h
