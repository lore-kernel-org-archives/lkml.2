Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0IWTS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:18:29 -0400
Received: from kroah.org ([198.145.64.141]:51285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab0IWTS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:18:27 -0400
Date: Thu, 23 Sep 2010 11:29:54 -0700
From: Greg KH <greg@kroah.com>
To: Paolo Ornati <ornati@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, stable@kernel.org
Subject: Re: [stable] 2.6.32.y needs ACPI workaround on ASUS K50IJ
Message-ID: <20100923182954.GO23040@kroah.com>
References: <20100912134531.6a97e833@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912134531.6a97e833@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 01:45:31PM +0200, Paolo Ornati wrote:
> Hello,
> 
> ASUS K50IJ needs the following ACPI workaround on 2.6.32.y (2.6.33+ is
> fine).
> 
> Since many distros are based / basing on 2.6.32.y i think it makes sense
> to include the fix in the upstream stable tree :)

Now queued up.

thanks,

greg k-h
