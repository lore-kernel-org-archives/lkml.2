Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2IGPLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:11:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54542 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2IGPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:11:47 -0400
Date: Fri, 7 Sep 2012 08:11:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] extcon: arizona: Use bypass mode for MICVDD
Message-ID: <20120907151143.GC7157@kroah.com>
References: <1347011091-32209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347011091-32209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 05:44:51PM +0800, Mark Brown wrote:
> We can perform microphone detection with MICVDD in bypass mode so try to
> enable that during startup for minimal power - other users or machine
> constraints will prevent bypass mode being activated if it is unsuitable.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This depends on the newly added regulator bypass support which will be
> going in during the merge window so probably the easiest thing here is
> if I apply this to the regulator tree?  I will be publishing a signed
> tag if you want to pull it in but for a simple, non-invasive change like
> this it seems like more trouble than it's worth.

No objection from me for you to take this through the regulator tree:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
