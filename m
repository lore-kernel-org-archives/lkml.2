Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab2F0JPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:15:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab2F0JPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:15:40 -0400
Date: Wed, 27 Jun 2012 12:15:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 0/6] kvm: level triggered irqfd support
Message-ID: <20120627091539.GC17507@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627044758.23698.249.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:08:52PM -0600, Alex Williamson wrote:
> I don't address whether injecting an edge irqfd really needs an assert
> followed by de-assert (I don't know).

So I just sent a patch removing that (works fine for me),
and we'll see what others say. If it gets applied
your patch will get smaller.

-- 
MST
