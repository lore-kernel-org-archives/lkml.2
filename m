Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1DMNRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:17:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45649 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab1DMNRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:17:21 -0400
Date: Wed, 13 Apr 2011 14:17:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@linux.jf.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] gma500: backlight warning
Message-ID: <20110413131714.GA17918@srcf.ucam.org>
References: <20110413093519.28527.36552.stgit@localhost.localdomain>
 <20110413093555.28527.30662.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413093555.28527.30662.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:36:19AM +0100, Alan Cox wrote:
>  	props.max_brightness = 100;
> +	props.type = BACKLIGHT_PLATFORM;

No, this should be BACKLIGHT_RAW - it's hitting the control registers 
directly rather than going via a platform interface.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
