Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0FOEef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:34:35 -0400
Received: from ozlabs.org ([203.10.76.45]:33029 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab0FOEee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:34:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH for-2.6.35] virtio: return ENOMEM on out of memory
Date: Tue, 15 Jun 2010 14:04:30 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Amit Shah <amit.shah@redhat.com>, Mark McLoughlin <markmc@redhat.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <20100610151611.GA3430@redhat.com>
In-Reply-To: <20100610151611.GA3430@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006151404.31216.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 12:46:11 am Michael S. Tsirkin wrote:
> add_buf returns ring size on out of memory,
> this is not what devices expect.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Yep.  These should all be cc'd to -stable as well?

Thanks,
Rusty.
