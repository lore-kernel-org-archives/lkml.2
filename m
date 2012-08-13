Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2HMPHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:07:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58238 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213Ab2HMPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:07:41 -0400
Date: Mon, 13 Aug 2012 16:07:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timekeeping: Fix build when generic clockevents are
 enabled
Message-ID: <20120813150738.GG13446@opensource.wolfsonmicro.com>
References: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <alpine.LFD.2.02.1208131706440.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208131706440.32033@ionos>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 05:07:06PM +0200, Thomas Gleixner wrote:
> On Thu, 9 Aug 2012, Mark Brown wrote:

> > Commit a2c204 (timekeeping: Add suspend and resume of clock event devices)

> Against which tree is that?

-next.  I think Raphael already folded it into the offending commit.
