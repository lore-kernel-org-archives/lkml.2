Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab0LVMTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:19:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34424 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751253Ab0LVMTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:19:50 -0500
Date: Wed, 22 Dec 2010 12:19:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jean Delvare <khali@linux-fr.org>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 1/2] PM: Prototype the pm_generic_ operations
Message-ID: <20101222121958.GA13320@opensource.wolfsonmicro.com>
References: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201012202208.59102.rjw@sisk.pl>
 <20101222114316.GA4520@sirena.org.uk>
 <201012221315.06948.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012221315.06948.rjw@sisk.pl>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 01:15:06PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, December 22, 2010, Mark Brown wrote:

> > Given the nearness of the merge window another option is to apply this
> > one now and punt the I2C one until 2.6.38, I guess?

> Except that I don't have any more fixes for 2.6.37 pending
> and this one isn't really a fix. :-)

Oh, sorry - I mean during the merge window rather than for 2.6.37.
