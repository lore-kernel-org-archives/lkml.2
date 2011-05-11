Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1EKWka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:40:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56957 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab1EKWkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XBwPYGBDEIcgjv4ZO8tBb5P7IiE64TIAmMfKb3Y+0hyXFcjnqsRzqOlkDy12jrYyRU
         HPhqCNigzKH3pLUQJnUjAsByCRc7wo+taDtxGKB87/wWxDqUjT6puLeVOns2xSZW913T
         /yJLCbFvOdwQMr5SlogjEZmTxtsSZativvg2c=
Date: Wed, 11 May 2011 15:40:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: riyer@nvidia.com
Cc: rydberg@euromail.se, amartin@nvidia.com, olof@lixom.net,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [v2] Input: tegra-kbc - modify keypress wakeup logic.
Message-ID: <20110511224018.GE11178@core.coreip.homeip.net>
References: <1304968957-10288-1-git-send-email-riyer@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304968957-10288-1-git-send-email-riyer@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 12:22:37PM -0700, riyer@nvidia.com wrote:
> From: Rakesh Iyer <riyer@nvidia.com>
> 
> Modify wakeup logic so either all keypresses wake the system or none do.
> 

Applied, thanks Rakesh.

-- 
Dmitry
