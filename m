Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985Ab2JaHd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:33:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47785 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab2JaHd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:33:26 -0400
Date: Wed, 31 Oct 2012 09:33:23 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Sasha Levin <levinsasha928@gmail.com>, Asias He <asias.hejun@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [BUG] lkvm crash on crashkernel boot
In-Reply-To: <20121025121645.GA28475@otc-wbsnb-06>
Message-ID: <alpine.LFD.2.02.1210310932350.2281@tux.localdomain>
References: <20121024152740.GA25303@otc-wbsnb-06> <CAOJsxLFD36jYiyE5sfN+uPT5G9G9ttf=K2UB=abEjBiTFNeehA@mail.gmail.com> <20121025121645.GA28475@otc-wbsnb-06>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Kirill A. Shutemov wrote:
> vec is 0xFFFF in virtio_pci__specific_io_out() on crash.
> 
> Let's add proper bounds checking there. It doesn't not solves the issue
> with booting crashkernel, but fix lkvm crash.

There's no sign-off for the patch. Kirill, care to update the patch 
description and send it my way?
