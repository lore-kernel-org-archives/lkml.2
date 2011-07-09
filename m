Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1GIDJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 23:09:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59572 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896Ab1GIDJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 23:09:04 -0400
Date: Sat, 9 Jul 2011 12:08:55 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator: Add a new regulator for charge control of
 MAX8998/LP3974
Message-ID: <20110709030853.GA23634@opensource.wolfsonmicro.com>
References: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
 <1308909859-3674-3-git-send-email-dg77.kim@samsung.com>
 <20110708131655.GB32754@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708131655.GB32754@oksana.dev.rtsoft.ru>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 05:16:55PM +0400, Anton Vorontsov wrote:

> Can I take it via battery-2.6.git tree?

As I've said before I'm still not really happy that these regulators can
meaningfully be generic regulator drivers rather than just being handled
as part of the PMU driver.
