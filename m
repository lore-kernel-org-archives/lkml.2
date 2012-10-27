Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2J0H44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 03:56:56 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:59077 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2J0H4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 03:56:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210261830200.1981@tux.localdomain>
References: <20121024152740.GA25303@otc-wbsnb-06> <CAOJsxLFD36jYiyE5sfN+uPT5G9G9ttf=K2UB=abEjBiTFNeehA@mail.gmail.com>
 <20121025121645.GA28475@otc-wbsnb-06> <CA+1xoqdN0AhLTczH6u1KngiOA61Ej1tL+v-FHAajqYO3tyGSwg@mail.gmail.com>
 <alpine.LFD.2.02.1210261830200.1981@tux.localdomain>
From: Asias He <asias.hejun@gmail.com>
Date: Sat, 27 Oct 2012 15:56:12 +0800
Message-ID: <CAFO3S40UeMJOe7NU=E+6fiZ_dU=4S_6qzEN8zATaK0Viu-NNng@mail.gmail.com>
Subject: Re: [BUG] lkvm crash on crashkernel boot
To: Pekka Enberg <penberg@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:31 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Thu, 25 Oct 2012, Sasha Levin wrote:
>> I think we're seeing that because we don't handle VIRTIO_MSI_NO_VECTOR properly.
>>
>> We need to deal with the ability to remove GSI & friends as well. I've
>> added it to my workqueue (unless someone deals with it first).
>
> Any reason I shouldn't apply Kirill's patch before someone find the time
> to do that?

Please apply it.

-- 
Asias He
