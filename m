Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1CPNzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:55:47 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44390 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab1CPNzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:55:39 -0400
Date: Wed, 16 Mar 2011 15:55:35 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <damm@opensource.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] device: add dev_WARN_ON and dev_WARN_ONCE
Message-ID: <20110316135533.GM2325@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1300283514-27105-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300283514-27105-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 03:51:54PM +0200, Felipe Balbi wrote:
> +#define dev_WARN_ON(dev, condition, format, arg...) \
> +	WARN_ON(condition, "Device: %s\n" format,  \
> +			dev_driver_string(dev), ## arg)

oops, I mis-used WARN_ON. Will fix and resend... just a sec.

-- 
balbi
