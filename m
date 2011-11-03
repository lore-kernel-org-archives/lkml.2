Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1KCLCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 07:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab1KCLC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 07:02:28 -0400
Date: Thu, 3 Nov 2011 13:03:39 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: virtio-pci new configuration proposal
Message-ID: <20111103110339.GB18296@redhat.com>
References: <1320259767.22582.2.camel@lappy>
 <8762j2t19l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8762j2t19l.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 12:28:46PM +1030, Rusty Russell wrote:
> 3) If we're changing the queue layout, it's a chance to fix a
>    longstanding bug: let the guest notify the host of preferred
>    queue size and alignment.

With device config split from the common one, we can
just tuck new fields at the tail of the common one.

-- 
MST
