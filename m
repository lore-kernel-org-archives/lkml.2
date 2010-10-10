Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0JJVTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 17:19:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58202 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0JJVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 17:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DLUnynynunS9Q7tAXux+R+ImIjSorLkvyk2P3N4dMQdsqHUQGejVF2vFW/1byfJUn6
         ZqoeD8GdjgRIKdfoFReMUOBm6Z2NUXJtSHNrbuRz/rLCCMjaLt5684wmB7VpRtvDmPQ8
         hkSa+F4at+3aqCNnxjBDnBc6ZW69d0r20iSvQ=
Date: Sun, 10 Oct 2010 14:19:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] input / sysrq fixes for use with kdb
Message-ID: <20101010211944.GB27553@core.coreip.homeip.net>
References: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 03:35:45PM -0500, Jason Wessel wrote:
> The goal of this patch set is to help eliminate the problems of
> resuming from the kernel debugger and having "stuck keys".
> 
> I am completely open to moving the code chunks around if it makes more
> sense to put the function in the input.c.
> 
> I had posted the first patch in the series before and never received
> an ack or acceptance into the linux-input merge queue.
> 

Jason,

I am aware of the problem however I am not quite happy with the proposed
solution yet. Let me mull it over for a bit and I will get back to you.

Thanks.

-- 
Dmitry
