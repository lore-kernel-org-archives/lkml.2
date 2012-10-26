Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab2JZPbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:31:06 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60239 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782Ab2JZPbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:31:03 -0400
Date: Fri, 26 Oct 2012 18:31:00 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Sasha Levin <levinsasha928@gmail.com>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [BUG] lkvm crash on crashkernel boot
In-Reply-To: <CA+1xoqdN0AhLTczH6u1KngiOA61Ej1tL+v-FHAajqYO3tyGSwg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1210261830200.1981@tux.localdomain>
References: <20121024152740.GA25303@otc-wbsnb-06> <CAOJsxLFD36jYiyE5sfN+uPT5G9G9ttf=K2UB=abEjBiTFNeehA@mail.gmail.com> <20121025121645.GA28475@otc-wbsnb-06> <CA+1xoqdN0AhLTczH6u1KngiOA61Ej1tL+v-FHAajqYO3tyGSwg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Sasha Levin wrote:
> I think we're seeing that because we don't handle VIRTIO_MSI_NO_VECTOR properly.
> 
> We need to deal with the ability to remove GSI & friends as well. I've
> added it to my workqueue (unless someone deals with it first).

Any reason I shouldn't apply Kirill's patch before someone find the time 
to do that?

			Pekka
