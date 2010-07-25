Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0GYVUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:20:21 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:50890 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0GYVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:20:20 -0400
Date: Mon, 26 Jul 2010 00:14:57 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Hari Kanigeri <hari.kanigeri@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap3: make coresight register save across OFF modes a
 sysfs option
Message-ID: <20100725211457.GB14399@shisha.kicks-ass.net>
Mail-Followup-To: Hari Kanigeri <hari.kanigeri@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <AANLkTinmSJ6dtgqmyuk9CArniPEvEp7TrXauvGxLxv7x@mail.gmail.com>
 <1280091863-8891-1-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280091863-8891-1-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 12:04:23 +0300, Alexander Shishkin wrote:
> This adds a sysfs file at /sys/power/coresight_save which is used to
> control if the ETM and debug components' states should be saved and
> restored across OFF modes.

Oops, I wanted to resend the previous patch, but it's getting late here.
Sorry for the spam.

Regards,
--
Alex
