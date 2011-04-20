Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab1DTUxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:53:07 -0400
Received: from kroah.org ([198.145.64.141]:46382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab1DTUxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:53:04 -0400
Date: Wed, 20 Apr 2011 13:48:45 -0700
From: Greg KH <greg@kroah.com>
To: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: keucr: smscsi: Includes missing KERN_
 facility level to printk().
Message-ID: <20110420204845.GA23207@kroah.com>
References: <1301167319-27552-1-git-send-email-ralf.thielow@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301167319-27552-1-git-send-email-ralf.thielow@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 08:21:59PM +0100, Ralf Thielow wrote:
> Includes missing KERN_ facility level to printk().
> 
> Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
> ---
>  drivers/staging/keucr/smscsi.c |    6 +++---

Does not apply cleanly :(
