Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255Ab2DLNpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:45:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2DLNpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:45:33 -0400
Date: Thu, 12 Apr 2012 10:45:29 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8139cp: set intr mask after its handler is registered
Message-ID: <20120412104529.27ece685@asterix.rh>
In-Reply-To: <20120412081053.25774.41676.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120412081053.25774.41676.stgit@amd-6168-8-1.englab.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 16:10:54 +0800
Jason Wang <jasowang@redhat.com> wrote:

> We set intr mask before its handler is registered, this does not work well when
> 8139cp is sharing irq line with other devices. As the irq could be enabled by
> the device before 8139cp's hander is registered which may lead unhandled
> irq. Fix this by introducing an helper cp_irq_enable() and call it after
> request_irq().
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Reviewed-by: Flavio Leitner <fbl@redhat.com>

fbl
