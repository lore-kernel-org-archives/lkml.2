Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2EBWpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:45:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50017 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903Ab2EBWpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:45:15 -0400
Date: Wed, 2 May 2012 23:45:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, myungjoo.ham@samsung.com,
        gregkh@linuxfoundation.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] Extcon: fix section mismatch in extcon_gpio.c
Message-ID: <20120502224510.GA19693@opensource.wolfsonmicro.com>
References: <201205021538.45056.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205021538.45056.hartleys@visionengravers.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 03:38:44PM -0700, H Hartley Sweeten wrote:
> Fix the section mismatch be renaming the struct platform_driver
> variable.

I'm pretty sure I sent a version of this patch sometime last week :/
