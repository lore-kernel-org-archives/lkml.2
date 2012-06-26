Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2FZSws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:52:48 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:42740 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753061Ab2FZSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:52:47 -0400
Date: Tue, 26 Jun 2012 20:52:45 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Oskar Schirmer <oskar@scara.com>
Cc: linux-kernel@vger.kernel.org, Corey Minyard <minyard@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] char/ipmi: remove local ioctl defines replaced by generic ones
Message-ID: <20120626185245.GE735@spo001.leaseweb.com>
References: <1338456523-12390-1-git-send-email-oskar@scara.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338456523-12390-1-git-send-email-oskar@scara.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

> This watchdog driver had ioctl defines introduced locally
> for pre timeout handling, marked to be removed as soon as
> a generic replacement would become available.
> 
> The latter has actually occurred in 2006, at e05b59fe.
> 
> Remove the local duplicates for pre timeout handling.
> 
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Cc: Corey Minyard <minyard@acm.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Added to linux-watchdog-next.

Kind regards,
Wim.

