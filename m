Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab0ETSLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:11:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756139Ab0ETSFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:05:13 -0400
Date: Thu, 20 May 2010 11:04:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: felipe.balbi@nokia.com
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/6] teach gpiolib about gpio debouncing
Message-Id: <20100520110431.58c42ee8.akpm@linux-foundation.org>
In-Reply-To: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 13:02:29 +0300
felipe.balbi@nokia.com wrote:

> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> Hi all,
> 
> I'm resending this series since no-one has had any further
> comments for quite some time.
> 
> Adding Andrew Morton to the loop also since David Brownell
> didn't pick the patch neither comment to any version of it.

David's been very quiet lately - please always cc me on gpio patches.

When were these first sent?  Has there been any feedback or external
testing?

I'm not seeing anything in the changelogs which helps me to understand
how important this feature is and it's rather late to be merging
2.6.35 feature work..

