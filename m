Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1AUUqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:46:46 -0500
Received: from kroah.org ([198.145.64.141]:38351 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1AUUqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:46:32 -0500
Date: Fri, 21 Jan 2011 12:45:17 -0800
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Staging: zram: simplify zram_make_request
Message-ID: <20110121204517.GA28587@kroah.com>
References: <4D0B88E5.4040005@redhat.com>
 <4D0B89F7.1000103@redhat.com>
 <4D38D6DE.10405@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D38D6DE.10405@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 07:44:14PM -0500, Nitin Gupta wrote:
> 
> zram_read() and zram_write() always return zero, so make them return
> void to simplify the code.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

Ick, this patch is line-wrapped and extra spaces are in every line
making it impossible to apply, unless I edit it by hand, which I really
don't want to do.

Care to fix this and resend?

thanks,

greg k-h
