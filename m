Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0LVLnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:43:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58823 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0LVLnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:43:21 -0500
Date: Wed, 22 Dec 2010 11:43:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jean Delvare <khali@linux-fr.org>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 1/2] PM: Prototype the pm_generic_ operations
Message-ID: <20101222114316.GA4520@sirena.org.uk>
References: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201012202208.59102.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012202208.59102.rjw@sisk.pl>
X-Cookie: Yow!  Now we can become alcoholics!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 10:08:58PM +0100, Rafael J. Wysocki wrote:

> I'd take this one, but the second one depends on it.

> I can take both if Jean agrees.

Given the nearness of the merge window another option is to apply this
one now and punt the I2C one until 2.6.38, I guess?
