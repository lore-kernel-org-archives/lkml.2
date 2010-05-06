Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab0EFSLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:11:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45802 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0EFSLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:11:41 -0400
Date: Thu, 6 May 2010 19:01:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jiri Olsa <jolsa@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com
Subject: Re: [PATCH] removing redundant ifdefs
Message-ID: <20100506180114.GB15797@n2100.arm.linux.org.uk>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 07:36:04PM +0200, Jiri Olsa wrote:
>  arch/arm/include/asm/processor.h              |    2 --
>  arch/arm/mach-ixp23xx/include/mach/platform.h |    3 ---
>  arch/arm/plat-omap/include/plat/clock.h       |    5 -----

I've not received any patches relating to the above, but I seem to
have received everything else, including stuff for PPC and x86.

Maybe you've negated the list of people to send patches to?
