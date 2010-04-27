Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0D0VJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:09:46 -0400
Received: from kroah.org ([198.145.64.141]:49323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab0D0VJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:09:44 -0400
Date: Tue, 27 Apr 2010 13:40:17 -0700
From: Greg KH <greg@kroah.com>
To: Jacob David <jacobselvin@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, hohndel@infradead.org, jkosina@suse.cz,
       jsd_syd@yahoo.com.au, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Staging: comedi: fixes the checkpatch error in skel.c
Message-ID: <20100427204017.GA26459@kroah.com>
References: <1268448694-5588-1-git-send-email-jsd_syd@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268448694-5588-1-git-send-email-jsd_syd@yahoo.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 01:51:34PM +1100, Jacob David wrote:
> From: Jacob David <jacobselvin@gmail.com>
> 
> This is a patch to the skel.c file that fixes the 80 line exceeding
> warning and the printk warning found by chekpatch.pl tool

Sorry, but someone already sent in a patch to do this same thing.

greg k-h
