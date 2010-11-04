Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0KDJOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:14:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab0KDJOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:14:21 -0400
Date: Thu, 4 Nov 2010 11:13:58 +0200
From: Alon Levy <alevy@redhat.com>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        QEMU Developers <qemu-devel@nongnu.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org, Avi Kivity <avi@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
Message-ID: <20101104091358.GA28832@playa.tlv.redhat.com>
References: <1097264455.965471288612409433.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <4CCEC090.3050009@codemonkey.ws>
 <4CD1A406.3090909@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD1A406.3090909@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 06:03:50PM +0000, Ian Molton wrote:
> On 01/11/10 13:28, Anthony Liguori wrote:
> >On 11/01/2010 06:53 AM, Alon Levy wrote:
> 
> >>While we (speaking as part of the SPICE developers) want to have the same
> >>support in our virtual GPU for 3d as we have for 2d, we just don't at
> >>this point of time.
> 
> Would it be helpful to you to have /something/ that works in the
> interim? I'm happy to work with you guys so that we dont need to
> reinvent the wheel ;-)
> 

In case it wasn't clear, I think putting virtio-gl is a good idea, exactly because it works right now.

[Snip]
