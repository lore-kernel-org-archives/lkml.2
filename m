Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab1IOJqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 05:46:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41814 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755479Ab1IOJqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:46:49 -0400
Date: Thu, 15 Sep 2011 10:46:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk+alsa@arm.linux.org.uk>
Cc: Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build
 failure
Message-ID: <20110915094640.GA7988@opensource.wolfsonmicro.com>
References: <1315991893.17271.2.camel@phoenix>
 <20110914191917.GA30518@flint.arm.linux.org.uk>
 <20110914232808.GC2953@opensource.wolfsonmicro.com>
 <20110914233838.GB22946@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914233838.GB22946@flint.arm.linux.org.uk>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 12:38:39AM +0100, Russell King wrote:
> On Thu, Sep 15, 2011 at 12:28:09AM +0100, Mark Brown wrote:
> > On Wed, Sep 14, 2011 at 08:19:17PM +0100, Russell King wrote:

> > ...this is true a substantial proportion of the GTA01 devices out there
> > are in the hands of people who might hack on it.

> Point at a mainline kernel which includes support for the neo1973_gta01
> platform.

I don't recall saying that there has been one; however I have seen
reasonable (if sporadic) efforts at getting the two boards mainlined -
it took years to get GTA02 in there but it did happen.
