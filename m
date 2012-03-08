Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab2CHUvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:51:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33677 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2CHUvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:51:50 -0500
Date: Thu, 8 Mar 2012 12:51:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 00/68] TTY buffer in tty_port -- prep no. 1
Message-ID: <20120308205146.GA16194@kroah.com>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 02:51:47PM +0100, Jiri Slaby wrote:
> Hi,
> 								      
> this is the first series of patches which allow tty buffers to be
> moved from tty_struct (present from open to close/hangup) to tty_port
> (present as long as the device). This will allow us to get rid of the
> tty refcounting in the interrupt service routines and other hot paths
> after we are done. This is because we won't need to handle races among
> ISRs, timers, hangups and others, because tty_port lives as long as an
> interrupt/timer tick may occur. Unlike tty_struct.
> 
> In this series, only first few drivers are converted to use
> tty_port. The rest is to come later.

Very nice work, all queued up now.

greg k-h
