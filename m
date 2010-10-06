Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab0JFVBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:01:42 -0400
Received: from kroah.org ([198.145.64.141]:56504 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095Ab0JFVBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:01:40 -0400
Date: Wed, 6 Oct 2010 14:01:20 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32.y] ipmi: Fix hard-code path ipmi exit path panic
Message-ID: <20101006210120.GB6184@kroah.com>
References: <4C9CDEEF.4030304@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9CDEEF.4030304@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 10:25:03AM -0700, Yinghai Lu wrote:
> 
> Wing found panic on X4800, after he installed Sun own special version of ipmitool.

Is this an issue on 2.6.35?  If so, please lt the ipmi maintainer know
about it so this patch can get into Linus's tree and then backported to
the stable releases.

thanks,

greg k-h
