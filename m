Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab0FKMXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:23:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759976Ab0FKMXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:23:31 -0400
Date: Fri, 11 Jun 2010 17:54:49 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mark McLoughlin <markmc@redhat.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-2.6.35] virtio: return ENOMEM on out of memory
Message-ID: <20100611122449.GT20595@amit-laptop.redhat.com>
References: <20100610151611.GA3430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610151611.GA3430@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Jun 10 2010 [18:16:11], Michael S. Tsirkin wrote:
> add_buf returns ring size on out of memory,
> this is not what devices expect.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Amit Shah <amit.shah@redhat.com>

		Amit
