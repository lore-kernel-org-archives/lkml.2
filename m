Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1A2ItF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:49:05 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52406 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1A2ItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:49:02 -0500
Subject: Re: [PATCH 5/7] [v2] zram/xvmalloc: Close 32byte hole on 64bit CPUs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110128150002.GF2062@linux.vnet.ibm.com>
References: <20110128145602.GA2062@linux.vnet.ibm.com>
	 <20110128150002.GF2062@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 29 Jan 2011 10:49:01 +0200
Message-ID: <1296290941.30654.9.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 09:00 -0600, Robert Jennings wrote:
> By swapping the total_pages statistic with the lock we close a
> hole in the structure for 64-bit CPUs.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

