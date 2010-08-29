Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0H2NG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:06:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51190 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752334Ab0H2NG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:06:26 -0400
Date: Sun, 29 Aug 2010 14:06:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] drivers/regulator: Remove double test
Message-ID: <20100829130642.GA10233@opensource.wolfsonmicro.com>
References: <1283010066-20935-1-git-send-email-julia@diku.dk>
 <1283010066-20935-6-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283010066-20935-6-git-send-email-julia@diku.dk>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 05:41:04PM +0200, Julia Lawall wrote:
> The current code tests the gpio_vid0 field twice.  Test the gpio_vid1
> fields in place of the second gpio_vid0 test.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
