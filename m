Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2HMMar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:30:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51587 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab2HMMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:30:46 -0400
Date: Mon, 13 Aug 2012 13:30:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] regulator: core: Add checking n_voltages if using
 list_voltage() to read voltage regulators
Message-ID: <20120813123043.GC13446@opensource.wolfsonmicro.com>
References: <1344562353.2996.1.camel@phoenix>
 <20120810100547.GG24328@opensource.wolfsonmicro.com>
 <CAF+7xWmmuf0bSROpvd+2RW-XFV=_nf6Zu3KC9-hW2rWDwVwncg@mail.gmail.com>
 <20120810122903.GJ24328@opensource.wolfsonmicro.com>
 <CAF+7xWnmoopw1-GEBAFe5Jsats5Zu5Xw0mJKqVX8Jf7QCCcFkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWnmoopw1-GEBAFe5Jsats5Zu5Xw0mJKqVX8Jf7QCCcFkg@mail.gmail.com>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 10:22:54AM +0800, Axel Lin wrote:

> We do have such case in drivers/regulator/max1586.c

They should have a read operation implemented.
