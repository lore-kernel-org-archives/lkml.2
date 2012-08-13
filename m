Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2HMUUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab2HMUUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:48 -0400
Date: Mon, 13 Aug 2012 22:20:32 +0200
From: Karel Zak <kzak@redhat.com>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        psusi@ubuntu.com, vgoyal@redhat.comi, maxim.patlasov@gmail.com,
        util-linux@vger.kernel.org
Subject: Re: [patch 2/2] util-linux: resizepart: Utility to resize a partition
Message-ID: <20120813202032.GA20252@x2.net.home>
References: <20120709213418.799759100@redhat.com>
 <20120709213559.918409313@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709213559.918409313@redhat.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 05:34:20PM -0400, vgoyal@redhat.com wrote:
> A simple user space utility to resize an existing partition. It tries to read
> the start of partiton from sysfs.

Applied with some changes -- will be in the next release util-linux 2.22-rc2

Thanks!

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
