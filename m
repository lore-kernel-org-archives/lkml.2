Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0LWL5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:57:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44418 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752901Ab0LWL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:57:15 -0500
Date: Thu, 23 Dec 2010 11:57:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH] regulator MAX8998/LP3974 Bufgix: accessing array out
 of bound.
Message-ID: <20101223115726.GD14481@opensource.wolfsonmicro.com>
References: <1293093868-24037-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293093868-24037-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 05:44:28PM +0900, MyungJoo Ham wrote:
> The previous driver may access ldo_voltage_map[] out of its bound at
> probe function at line 790 (drivers/regulator/max8998.c). This patch
> allocates an entry for every regulator in order to avoid accessing
> out-of-bounds.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

If reposting a previously acked patch then please add the ack to the
patch - makes life easier when reviewing.  If you change the patch then
it needs rechecking but otherwise just keep the acks.
