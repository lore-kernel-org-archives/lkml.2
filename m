Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2DSPRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:17:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51420 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2DSPRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:17:47 -0400
Date: Thu, 19 Apr 2012 08:17:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        artem.bityutskiy@linux.intel.com, shubhrajyoti@ti.com
Subject: Re: [PATCH 0/6] HSI fixes for 3.4
Message-ID: <20120419151741.GC31543@kroah.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 03:05:21PM +0300, Carlos Chinea wrote:
> Hi,
> 
> This patch set contains fixes for the issues found by Greg KH
> 
> https://lkml.org/lkml/2012/4/2/511
> https://lkml.org/lkml/2012/4/2/512
> 
> I would like to get feedback from those patches and specially
> from the hsi_event rework patch.

All of these look great to me, thanks for doing this rework, I no longer
have any objections to the code at all.  Feel free to add:

	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

To them if you wish.

thanks,

greg k-h
