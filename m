Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2GSNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2GSNJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:09:24 -0400
Date: Thu, 19 Jul 2012 16:09:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Asias He <asias@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RESEND 5/5] vhost-blk: Add vhost-blk support
Message-ID: <20120719130957.GD9303@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
 <1342169711-12386-6-git-send-email-asias@redhat.com>
 <87mx2vrjdl.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mx2vrjdl.fsf@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 08:05:42AM -0500, Anthony Liguori wrote:
> Of course, the million dollar question is why would using AIO in the
> kernel be faster than using AIO in userspace?

Actually for me a more important question is how does it compare
with virtio-blk dataplane?

-- 
MST
