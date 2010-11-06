Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0KFLzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:55:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49554 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0KFLzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:55:47 -0400
Subject: Re: [PATCH 2/3 v2] regulator: Ensure enough delay time for
 enabling regulator
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20101105135954.GA15977@opensource.wolfsonmicro.com>
References: <1288965092.2312.3.camel@phoenix>
	 <20101105135954.GA15977@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 11:55:44 +0000
Message-ID: <1289044544.3318.17.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 09:59 -0400, Mark Brown wrote:
> On Fri, Nov 05, 2010 at 09:51:32PM +0800, Axel Lin wrote:
> > Integer division will truncate the result, this patch ensures we have
> > enough delay time for enabling regulator.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

All applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

