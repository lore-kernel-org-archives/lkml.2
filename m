Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2BIPXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:23:55 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:56765 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776Ab2BIPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:23:54 -0500
Message-ID: <1328801029.3951.7.camel@odin>
Subject: Re: [PATCH 1/2] regulator: Don't add the function name to pr_fmt
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Date: Thu, 09 Feb 2012 15:23:49 +0000
In-Reply-To: <1328794926-4892-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1328794926-4892-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 13:42 +0000, Mark Brown wrote:
> Liam pointed out via IM that since we now use the pure function name for
> all regulator logging a lot of the messages such as those logging the
> constraints are getting a bit noisy due to the implementation detail
> that is the function name:
> 
> print_constraints: VDDARM: 1000 <--> 1300 mV at 1300 mV at 0 mA
> 
> In discussion it seemed like the best thing was to just drop the pr_fmt
> and clarify individual log messages where there is an issue otherwise
> we get into silly things like renaming the functions to suit the logging.
> 
> This is mostly an issue as we have a moderate amount of non-error logging
> in the boot sequence to aid debug if something goes wrong since regulator
> misconfiguration can kill the system pretty quickly.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Both

Acked-by: Liam Girdwood <lrg@ti.com>

