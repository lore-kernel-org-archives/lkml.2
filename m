Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2ECSCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:02:05 -0400
Received: from tservice.ru ([195.178.208.66]:34832 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754185Ab2ECSCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:02:04 -0400
Date: Thu, 3 May 2012 22:02:02 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, GregKH <greg@kroah.com>
Subject: Re: [PATCH] w1: w1_ds2408.c: quite sparse noise about using plaing
 integer as NULL pointer
Message-ID: <20120503180202.GC13988@ioremap.net>
References: <201205021702.07694.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205021702.07694.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 05:02:07PM -0700, H Hartley Sweeten (hartleys@visionengravers.com) wrote:
> NULL not 0 should be used with pointers. Just remove the offending
> lines since they will default to NULL anyway.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>

Looks good, thank you
Greg, please pull it into your tree or should it be forwarded to
janitor list?

-- 
	Evgeniy Polyakov
