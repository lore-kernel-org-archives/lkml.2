Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2IQUWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:22:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55936 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2IQUWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:22:46 -0400
Date: Mon, 17 Sep 2012 13:22:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <morbidrsa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: staging: Line6 - Steps needed to get driver out of staging area
Message-ID: <20120917202238.GA18748@kroah.com>
References: <50560C5F.3020700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50560C5F.3020700@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 07:29:03PM +0200, Johannes Thumshirn wrote:
> Hi LKML,
> 
> I wanted to ask for the steps that are needed to get the line6
> driver out of the staging area (apart from minor getpatch.pl fixes).

First try asking on the proper mailing list :)

Second, it needs to be submitted to the subsystem that it should be in
(i.e. sound, right?)  It's up to those maintainers to say what's left to
do.

Are you willing to help out with this?  Right now it doesn't seem like
anyone is using the driver, or helping to clean it up.

thanks,

greg k-h
