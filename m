Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0GVSNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:13:37 -0400
Received: from kroah.org ([198.145.64.141]:56855 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0GVSNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:13:36 -0400
Date: Thu, 22 Jul 2010 11:06:41 -0700
From: Greg KH <greg@kroah.com>
To: Denis Kirjanov <dkirjanov@hera.kernel.org>
Cc: gregkh@suse.de, davem@davemloft.net, liodot@gmail.com,
        charrer@alacritech.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: Staging: slicoss: Remove net_device_stats from the driver's
 private
Message-ID: <20100722180641.GA9293@kroah.com>
References: <20100710204510.GA18748@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100710204510.GA18748@hera.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 08:45:10PM +0000, Denis Kirjanov wrote:
> Remove net_device_stats from the driver's private.

This patch breaks the build, did you even try it?

I can't apply it, sorry.

greg k-h
