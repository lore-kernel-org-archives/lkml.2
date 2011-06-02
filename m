Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab1FBKks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 06:40:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56900 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932591Ab1FBKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 06:40:47 -0400
Date: Thu, 2 Jun 2011 11:40:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Read wm831x AUXADC conversion results before
 acknowledging interrupt
Message-ID: <20110602104044.GE3085@opensource.wolfsonmicro.com>
References: <1307010516-11711-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307010516-11711-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 11:28:36AM +0100, Mark Brown wrote:
> Ensure that there's no possibility of loosing an AUXADC interrupt by reading
> the conversion result in the IRQ handler when using interrupts. Otherwise
> it's possible that under very heavy load a new conversion could be initiated
> before the acknowledgement for a previous interrupt has happened.

Sorry, fat fingers with the commmit - new version coming shortly.
