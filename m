Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2BRKjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 05:39:52 -0500
Received: from corega.com.ru ([195.178.208.66]:49988 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751936Ab2BRKjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 05:39:51 -0500
Date: Sat, 18 Feb 2012 13:39:47 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Michael Thalmeier <michael.thalmeier@hale.at>
Cc: linux-kernel@vger.kernel.org, michael@thalmeier.at
Subject: Re: [PATCH 3/3] w1: add slave driver for DS1996 and DS1963L
Message-ID: <20120218103947.GB13028@ioremap.net>
References: <1329480422-7616-1-git-send-email-michael.thalmeier@hale.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329480422-7616-1-git-send-email-michael.thalmeier@hale.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Feb 17, 2012 at 01:07:02PM +0100, Michael Thalmeier (michael.thalmeier@hale.at) wrote:
> This driver adds support for some Dallas non-volatile memory 1-wire slave
> devices.
> 
> At the moment the following devices are supported:
> 
>  * family 0x0c: DS1996 64Kb Memory iButton
>  * family 0x1A: DS1963L 4kbit Monetary
> 
> Access to memory is done via pages exportedi in sysfs.
> 
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>

Looks good to me, although I would replace config option 
with sysfs-enabled parameter, since distros do not compile different
kernels with various options enabled.

-- 
	Evgeniy Polyakov
