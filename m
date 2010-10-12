Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab0JLNva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:51:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:34032 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932546Ab0JLNv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:51:28 -0400
Date: Tue, 12 Oct 2010 06:51:16 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Suchy <danny@danysek.cz>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PATCH: ftdi_sio new VID/PIDs for various Papouch devices
Message-ID: <20101012135116.GA11657@suse.de>
References: <4CB45E2A.9020407@danysek.cz> <20101012132208.GB10556@suse.de> <4CB463D1.4020204@danysek.cz> <20101012133753.GA11216@suse.de> <4CB46638.7060203@danysek.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB46638.7060203@danysek.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 03:44:24PM +0200, Daniel Suchy wrote:
> This patch for FTDI USB serial driver ads new VID/PIDs used on various
> devices manufactured by Papouch (http://www.papouch.com). These devices
> have their own VID/PID, although they're using standard FTDI chip. In
> ftdi_sio.c, I also made small cleanup to have declarations for all
> Papouch devices together.
> 
> Signed-off-by: Daniel Suchy <danny@danysek.cz>

Yeah!

Nice job, I'll queue this up in a few days for the next release.

greg k-h
