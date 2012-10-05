Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2JEHrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:47:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38105 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JEHrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:47:23 -0400
Message-ID: <506E9075.6000104@redhat.com>
Date: Fri, 05 Oct 2012 09:47:01 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Anthony Liguori <anthony@codemonkey.ws>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] virtio-net: inline header support
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf@rustcorp.com.au> <87mx033u74.fsf@codemonkey.ws> <87391u3o67.fsf@rustcorp.com.au> <87wqz6kgg4.fsf@codemonkey.ws> <87lifm1y1n.fsf@rustcorp.com.au>
In-Reply-To: <87lifm1y1n.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/10/2012 09:44, Rusty Russell ha scritto:
> -In particular, no implementation should use the descriptor
> -boundaries to determine the size of any header in a request.[footnote:
> -The current qemu device implementations mistakenly insist that
> -the first descriptor cover the header in these cases exactly, so
> -a cautious driver should arrange it so.
> +[footnote:
> +It was previously asserted that framing should be independent of
> +message contents, yet invariably drivers layed out messages in
> +reliable ways and devices assumed it. In addition, the
> +specifications for virtio_blk and virtio_scsi require intuiting
> +field lengths from frame boundaries.
>  ]

Not true for virtio_scsi...

Paolo
