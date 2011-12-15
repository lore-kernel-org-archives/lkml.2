Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab1LONL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:11:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1LONLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:11:24 -0500
Date: Thu, 15 Dec 2011 15:13:14 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 00/11]  virtio: s4 support
Message-ID: <20111215131314.GA22791@redhat.com>
References: <cover.1323952933.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1323952933.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 06:15:46PM +0530, Amit Shah wrote:
> Hi,
> 
> These patches add support for S4 to virtio (pci) and all drivers.
> 
> Michael saw some race in virtio-net module removal which will need a
> similar fix for the freeze code as well.  I'll update the virtio-net
> patch with that fix once the fix is settled upon and applied.

block too?

-- 
MST
