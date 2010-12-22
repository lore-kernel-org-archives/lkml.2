Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0LVMQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:16:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45624 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0LVMQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:16:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [linux-pm] [PATCH 1/2] PM: Prototype the pm_generic_ operations
Date: Wed, 22 Dec 2010 13:15:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-pm@lists.linux-foundation.org
References: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201012202208.59102.rjw@sisk.pl> <20101222114316.GA4520@sirena.org.uk>
In-Reply-To: <20101222114316.GA4520@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221315.06948.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 22, 2010, Mark Brown wrote:
> On Mon, Dec 20, 2010 at 10:08:58PM +0100, Rafael J. Wysocki wrote:
> 
> > I'd take this one, but the second one depends on it.
> 
> > I can take both if Jean agrees.
> 
> Given the nearness of the merge window another option is to apply this
> one now and punt the I2C one until 2.6.38, I guess?

Except that I don't have any more fixes for 2.6.37 pending
and this one isn't really a fix. :-)

If there's anything else I should push to Linus before 2.6.37, I'll
include this patch in the pull request.  Otherwise I think it shoul go in
during the merge window.

Thanks,
Rafael
