Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0DFLGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:06:15 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:38985 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0DFLGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:06:06 -0400
Subject: Re: [PATCH 0/4]-V3 TPS6507x MFD driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20100406105132.GC2688@rakim.wolfsonmicro.main>
References: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
	 <20100406105132.GC2688@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 12:05:59 +0100
Message-ID: <1270551959.3229.22.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Please feel free to upstream via MFD.

On Tue, 2010-04-06 at 11:51 +0100, Mark Brown wrote:
> On Mon, Apr 05, 2010 at 08:23:55PM -0600, Todd Fischer wrote:
> 
> > This is the third posting of the TPS6507x driver set.  I have
> > resolved the concurrent access issue identified by Mark Brown.
> > Instead of using a mutex, I used the i2c_transfer() as done in
> > the similar routine in the wm8400-core.c file.
> 
> All
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

