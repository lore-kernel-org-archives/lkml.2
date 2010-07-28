Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0G1PRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:17:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:57778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0G1PRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:17:00 -0400
Date: Wed, 28 Jul 2010 08:09:34 -0700
From: Greg KH <gregkh@suse.de>
To: Ernesto Ramos <ernesto@ti.com>
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 5/5] staging:ti dspbridge: replace simple_strtoul by
 strict_strtoul
Message-ID: <20100728150934.GA25299@suse.de>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
 <1280328052-31292-2-git-send-email-ernesto@ti.com>
 <1280328052-31292-3-git-send-email-ernesto@ti.com>
 <1280328052-31292-4-git-send-email-ernesto@ti.com>
 <1280328052-31292-5-git-send-email-ernesto@ti.com>
 <1280328052-31292-6-git-send-email-ernesto@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280328052-31292-6-git-send-email-ernesto@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 09:40:52AM -0500, Ernesto Ramos wrote:
> Replace simple_strtoul by strict_strtoul in atoi function.

Why not use the built-in kernel function instead of having your own atoi
function?

thanks,

greg k-h
