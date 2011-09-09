Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab1IIXMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:12:32 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34787 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934020Ab1IIXMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:12:30 -0400
X-Sasl-enc: fZ6SijpvlvIW7Lf2szJvedrE9j9grG8/OwMtwzlOpLh8 1315609950
Date: Fri, 9 Sep 2011 16:10:28 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Noah Watkins <noahwatkins@gmail.com>
Subject: Re: [PATCH 3/5] zram: Make gobal variables use unique names
Message-ID: <20110909231028.GA24587@kroah.com>
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org>
 <1315609264-13632-4-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315609264-13632-4-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 07:01:02PM -0400, Nitin Gupta wrote:
> Global variables 'num_devices' and 'devices' are too
> general to be global. This patch switches the name to
> be "zram_devices".
> 
> Signed-off-by: Noah Watkins <noahwatkins@gmail.com>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

I've already applied this patch, right?

confused,

greg k-h
