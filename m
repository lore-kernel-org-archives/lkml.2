Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1GKLaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:30:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35557 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1GKLaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:30:17 -0400
Date: Mon, 11 Jul 2011 14:28:44 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 13/13] Staging: comedi: fix indentation issue in pcl818.c
Message-ID: <20110711112844.GG18655@shale.localdomain>
References: <1310383800-17428-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310383800-17428-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 05:00:00PM +0530, Ravishankar wrote:
> @@ -242,8 +242,8 @@ static const struct comedi_lrange range_pcl818l_h_ai = { 4, {
>  };
>  
>  static const struct comedi_lrange range718_bipolar1 = { 1, {BIP_RANGE(1),} };
> -static const struct comedi_lrange range718_bipolar0_5 =
> -    { 1, {BIP_RANGE(0.5),} };
> +static const struct comedi_lrange range718_bipolar0_5 = { 1,
> +{BIP_RANGE(0.5),} };

The original was better.  Just replace the spaces with a tab.

regards,
dan carpenter

