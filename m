Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab1ESVIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:08:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49148 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753842Ab1ESVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:08:12 -0400
Date: Thu, 19 May 2011 14:08:15 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFC][PATCH] regulator: Fix _regulator_get_voltage if
 get_voltage callback is NULL
Message-ID: <20110519210815.GC18849@opensource.wolfsonmicro.com>
References: <1305723718.6172.6.camel@phoenix>
 <20110518163205.GC16414@opensource.wolfsonmicro.com>
 <BANLkTimU7FyuTuVw1ezOo381a798Ec+uCw@mail.gmail.com>
 <BANLkTinx-OPhDBVZFrz2V_o8-p4yfTt9Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinx-OPhDBVZFrz2V_o8-p4yfTt9Kg@mail.gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 05:58:06PM +0800, Axel Lin wrote:

> I'm thinking maybe you prefer changes like below:
> How do you think?

Yes, something like that.  The goto is obscure and hard to read.
