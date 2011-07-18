Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1GRM2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:28:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab1GRM2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:28:03 -0400
Date: Mon, 18 Jul 2011 15:28:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: jj@chaosbits.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv10] vhost: vhost TX zero-copy support
Message-ID: <20110718122804.GA5580@redhat.com>
References: <20110718105905.GA4786@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718105905.GA4786@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 01:59:05PM +0300, Michael S. Tsirkin wrote:
> This adds experimental zero copy support in vhost-net,
> disabled by default.

Looks like there was a memory leak in the patch,
I'll address that and post a new version shortly.

-- 
MST
