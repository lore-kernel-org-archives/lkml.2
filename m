Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0EaLXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:23:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58411 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751652Ab0EaLXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:23:32 -0400
Date: Mon, 31 May 2010 12:23:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/11] drivers/watchdog: Eliminate a NULL pointer
 dereference
Message-ID: <20100531112330.GI3489@rakim.wolfsonmicro.main>
References: <Pine.LNX.4.64.1005271432100.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005271432100.5422@ask.diku.dk>
X-Cookie: <ahzz_> i figured 17G oughta be enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 02:32:24PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> At the point of the call to dev_err, wm8350 is NULL.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
