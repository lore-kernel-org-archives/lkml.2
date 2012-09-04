Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab2IDXK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:10:26 -0400
Received: from ozlabs.org ([203.10.76.45]:51930 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920Ab2IDXKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:10:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kent Overstreet <koverstreet@google.com>, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
In-Reply-To: <20120903044133.GA9980@moria.home.lan>
References: <20120903044133.GA9980@moria.home.lan>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 04 Sep 2012 15:53:53 +0930
Message-ID: <87wr0ae26e.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
> instead.

This is a slight mis-understanding.  It's supposed to be selected by
the particular driver, probably virtio_pci in your case.

Cheers,
Rusty.
