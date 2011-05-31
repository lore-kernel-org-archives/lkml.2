Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1EaEIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 00:08:45 -0400
Received: from linux-sh.org ([111.68.239.195]:33110 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab1EaEIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 00:08:44 -0400
Date: Tue, 31 May 2011 13:08:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] Subject: shmobile: Fix build of the LCDC driver
Message-ID: <20110531040806.GB1745@linux-sh.org>
References: <201105280123.06622.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105280123.06622.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 01:23:06AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The shmobile lcdcfb driver fails to build because of the undefined
> ret variable in sh_mobile_lcdc_start().  Fix this problem.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> Hi,
> 
> I don't know whether this is known or not.  In case it isn't,
> here's a fix. :-)
> 
Already fixed in the fbdev tree, it'll be in the next round of updates.
