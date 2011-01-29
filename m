Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1A2Iss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:48:48 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52406 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1A2Isr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:48:47 -0500
Subject: Re: [PATCH 4/7] [v2] zram/xvmalloc: create CONFIG_ZRAM_DEBUG for
 debug code
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110128145926.GE2062@linux.vnet.ibm.com>
References: <20110128145602.GA2062@linux.vnet.ibm.com>
	 <20110128145926.GE2062@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 29 Jan 2011 10:48:46 +0200
Message-ID: <1296290926.30654.8.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 08:59 -0600, Robert Jennings wrote:
> Add a debug config flag to enable debug printk output and future
> debug code.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

