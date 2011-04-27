Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab1D0PRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:17:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:45170 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1D0PRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:17:43 -0400
Date: Wed, 27 Apr 2011 08:02:56 -0700
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 6/8] staging/mei: Header file contain the Userland API,
 (IOCTL and its struct)
Message-ID: <20110427150256.GA24596@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-7-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303900057-21694-7-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:27:35PM +0300, Oren Weil wrote:
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
> Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
> ---
>  include/linux/mei.h |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++

No, this needs to stay in the drivers/staging/mei/ directory, no staging
code can be outside of it's directory.

Please fix this and resend.

thanks,

greg k-h
