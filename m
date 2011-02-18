Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab1BRU3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:29:09 -0500
Received: from xes-mad.com ([216.165.139.218]:33505 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab1BRU3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:29:07 -0500
Subject: Re: [PATCH v3 4/4] gpio: Add support for Intel
 ICHx/3100/Series[56] GPIO
From: Peter Tyser <ptyser@xes-inc.com>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, Olof <olofj@chromium.org>,
        vbendeb <vbendeb@chromium.org>
In-Reply-To: <1298051894-30600-1-git-send-email-vpalatin@chromium.org>
References: <1297983799-4747-4-git-send-email-ptyser@xes-inc.com>
	 <1298051894-30600-1-git-send-email-vpalatin@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 14:28:29 -0600
Message-ID: <1298060909.965.20479.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 12:58 -0500, Vincent Palatin wrote:
> Hi,
> 
> I have tested it on a Pineview / Tigerpoint based board.
> It works well given you add the PCI ids for the tigerpoint/NM10 chipset
> (cf patch below).
> The Tigerpoint/NM10 is ICH7 based for the GPIO part.
> 
> Tested-by: Vincent Palatin <vpalatin@chromium.org>
> 
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>

Thanks for testing.  I'll add the Tigerpoint and your tested/signoff
when I resubmit.

Peter

