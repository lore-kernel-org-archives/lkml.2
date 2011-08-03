Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1HCO2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:28:48 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50496 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab1HCO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:28:41 -0400
X-Sasl-enc: Y/hnIntqrGi/0CrXAIMe+RzGN383kUbm8FQcLpQEuInc 1312381720
Date: Wed, 3 Aug 2011 07:26:28 -0700
From: Greg KH <greg@kroah.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: ngupta@vflare.org, dan.magenheimer@oracle.com, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, paul.gortmaker@windriver.com,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] zcache: include module.h for MODULE_LICENSE
Message-ID: <20110803142628.GA9756@kroah.com>
References: <20110803141641.00402b8e49dd68aa58c458ac@canb.auug.org.au>
 <1312380040-28249-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312380040-28249-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 11:00:40AM -0300, Thadeu Lima de Souza Cascardo wrote:
> The oncoming cleanup of module.h usage requires the explicit inclusion
> of module.h when it was otherwise being included indirectly. Otherwise,
> building zcache will fail.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Thanks, but you forgot the Reported-by: tag for this patch that you
should have added.  I've added it this time but please be more careful
next time.

greg k-h
