Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2AIQPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:15:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49811 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932170Ab2AIQO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:14:59 -0500
Date: Mon, 9 Jan 2012 08:14:57 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/regulator/core.c: Fixes mapping inside
 regulator_mode_to_status() and makes it returning -EINVAL on invalid input.
Message-ID: <20120109161456.GC2974@opensource.wolfsonmicro.com>
References: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 12:12:20PM +0000, Krystian Garbaciak wrote:
> Minor fix that makes the function working correctly with
> REGULATOR_MODE_STANDBY as parameter.
> Also, on invalid input (bad mode), it is better to return -EINVAL,
> instead of meaningless 0 value (which actually is interpreted as
> REGULATOR_STATUS_OFF).
> 
> --- 

As I previously said you need to follow the patch submission process in
SubmittingPatches.  Here you need to:

 - Sign off your patch.  Without this your patch cannot be applied.
 - Send the patches to the maintainers (not just one of them) and the
   list.

You should also make an effort to use subject lines for your patch that
match up with what the rest of the subsystem is doing.

>  	default:
> -		return 0;
> +		return -EINVAL;

This behaviour is deliberate.
