Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab2IDXMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:12:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51575 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab2IDXMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <87wr0ae26e.fsf@rustcorp.com.au>
References: <20120903044133.GA9980@moria.home.lan>
	<87wr0ae26e.fsf@rustcorp.com.au>
Date: Tue, 4 Sep 2012 16:12:50 -0700
Message-ID: <CAH+dOxKGg0ROpKos+633rvpe+r4BAZvY-ppXJwgnri=aipk2+Q@mail.gmail.com>
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
From: Kent Overstreet <koverstreet@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 11:23 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Kent Overstreet <koverstreet@google.com> writes:
>
>> CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
>> instead.
>
> This is a slight mis-understanding.  It's supposed to be selected by
> the particular driver, probably virtio_pci in your case.

Yes... VIRT_BLOCK isn't selecting it.
