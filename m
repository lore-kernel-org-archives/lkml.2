Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab0D0WbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:31:13 -0400
Received: from kroah.org ([198.145.64.141]:55928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374Ab0D0WaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:30:07 -0400
Date: Tue, 27 Apr 2010 15:21:18 -0700
From: Greg KH <greg@kroah.com>
To: Jakob Penzien <jwpenzie@mtu.edu>
Cc: gregkh@suse.de, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: ni_labpc.c
Message-ID: <20100427222118.GA21875@kroah.com>
References: <4BBF8D27.6000501@mtu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBF8D27.6000501@mtu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 04:25:11PM -0400, Jakob Penzien wrote:
> Subject: [PATCH] Staging: comedi: Fixed brace, KERN_, 80 characters issues in ni_labpc.c
>  This is a patch to ni_labpc.c file that fixes all the brace
>  and 80 character warnings and it also fixes some of the KERN_ facility
>  warnings found by the checkpatch.pl tool. The two errors about indent warning
> are there because I do not understand what they want and so I left it in the orginal code
> and they happened to get pulled in the patch.
>  Signed-off-by: Jakob Penzien <supermine290@gmail.com>

This was already done by someone else before you :(

thanks,

greg k-h
