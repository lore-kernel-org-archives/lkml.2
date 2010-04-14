Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0DNMxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:53:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53544 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755074Ab0DNMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:53:07 -0400
Date: Wed, 14 Apr 2010 13:57:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Schnell <mschnell@lumino.de>
Cc: nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: atomic RAM ?
Message-ID: <20100414135704.3fc7b713@lxorguk.ukuu.org.uk>
In-Reply-To: <4BC5B915.6090803@lumino.de>
References: <4BBD86A5.5030109@lumino.de>
	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>
	<4BBDC7D4.6040301@lumino.de>
	<20100408143750.0acebaa1@lxorguk.ukuu.org.uk>
	<4BC5B915.6090803@lumino.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > FUTEX  ... is an implementation ...  for certain classes of processor.
> Alan,
> 
> If that is true "in depth", there should be no FUTEX-relevant  code,
> neither in the Kernel, nor in the library, that should be considered
> "arch-independent".

We have a lot of kernel code which is only usable on some architectures
and a few opt out of. The largest example of course being the mm layer
which is strictly for MMU equipped systems.

The important point is that you don't *have* to use futex to provide the
posix pthread lock primitives if they don't fit your platform.

