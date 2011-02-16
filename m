Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1BPWCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:02:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1BPWCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:02:50 -0500
Date: Wed, 16 Feb 2011 14:02:35 -0800
From: Greg KH <gregkh@suse.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: kernel@pengutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] RFC: introduce typechecking to
 platform_{get,set}_drvdata
Message-ID: <20110216220235.GA30120@suse.de>
References: <1297893351-2900-1-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297893351-2900-1-git-send-email-mkl@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 10:55:49PM +0100, Marc Kleine-Budde wrote:
> Hello,
> 
> just found a mis-user of platform_set_drvdata(), so introduce typechecking
> to these macro definitions. An alternative would be to make them static inline
> functions.

Make it a static inline, that way you don't have to create that new
macro, as the build will warn/break right away.

thanks,

greg k-h
