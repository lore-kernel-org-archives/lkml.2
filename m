Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab2JZPmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:42:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50111 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818Ab2JZPmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:42:10 -0400
Date: Fri, 26 Oct 2012 19:42:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [BUG] lkvm crash on crashkernel boot
Message-ID: <20121026154200.GM5500@moon>
References: <20121024152740.GA25303@otc-wbsnb-06>
 <CAOJsxLFD36jYiyE5sfN+uPT5G9G9ttf=K2UB=abEjBiTFNeehA@mail.gmail.com>
 <20121025121645.GA28475@otc-wbsnb-06>
 <CA+1xoqdN0AhLTczH6u1KngiOA61Ej1tL+v-FHAajqYO3tyGSwg@mail.gmail.com>
 <alpine.LFD.2.02.1210261830200.1981@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210261830200.1981@tux.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 06:31:00PM +0300, Pekka Enberg wrote:
> On Thu, 25 Oct 2012, Sasha Levin wrote:
> > I think we're seeing that because we don't handle VIRTIO_MSI_NO_VECTOR properly.
> > 
> > We need to deal with the ability to remove GSI & friends as well. I've
> > added it to my workqueue (unless someone deals with it first).
> 
> Any reason I shouldn't apply Kirill's patch before someone find the time 
> to do that?

I think it's worth to apply until proper fix appear.
