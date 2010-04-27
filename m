Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab0D0Wbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:31:37 -0400
Received: from kroah.org ([198.145.64.141]:55923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401Ab0D0WaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:30:06 -0400
Date: Tue, 27 Apr 2010 15:20:55 -0700
From: Greg KH <greg@kroah.com>
To: Maurice Dawson <mauricedawson2699@googlemail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/30] Staging: comedi: fix over 80 character coding
 style issues in ni_labpc.c
Message-ID: <20100427222055.GA21862@kroah.com>
References: <1270822424-3813-1-git-send-email-mauricedawson2699@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270822424-3813-1-git-send-email-mauricedawson2699@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 03:13:43PM +0100, Maurice Dawson wrote:
> This is a re-submitted patch to the ni_labpc.c file that fixes up over
> 80 characters warnings found by the checkpatch.pl tool
> 
> Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>

Hm, odd, this doesn't apply against the linux-next tree at all, can you
respin it to apply properly?

thanks,

greg k-h
