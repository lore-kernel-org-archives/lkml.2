Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab1CPEbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:31:13 -0400
Received: from ozlabs.org ([203.10.76.45]:58724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab1CPEbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:31:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 00/02] virtio: Virtio platform driver
In-Reply-To: <20110310070541.27327.52089.sendpatchset@t400s>
References: <20110310070541.27327.52089.sendpatchset@t400s>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Wed, 16 Mar 2011 14:16:13 +1030
Message-ID: <87d3lriv7e.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 16:05:41 +0900, Magnus Damm <magnus.damm@gmail.com> wrote:
> virtio: Virtio platform driver
> 
> [PATCH 01/02] virtio: Break out lguest virtio code to virtio_lguest.c
> [PATCH 02/02] virtio: Add virtio platform driver

I have no problem with these patches, but it's just churn until we see
your actual drivers.

The S/390 devs might be interested, as their bus is very similar too...

Cheers,
Rusty.
