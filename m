Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab2EWRaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:30:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55339 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760596Ab2EWRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:30:13 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-3-git-send-email-yinghai@kernel.org>
	<CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
Date: Wed, 23 May 2012 10:30:12 -0700
X-Google-Sender-Auth: 5f42FN0_rWDOKO6wk4VZ-wJBkic
Message-ID: <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 8:57 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 22, 2012 at 11:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> and will fall back to below 4g if it can not find any above 4g.
>
> Has this been tested on 32-bit machines without PAE? There might be
> things that just happen to work because their allocations were always
> done bottom-up.

Good point. that problem should be addressed at first before this patch.

>
> Or do we have something else that protects us from the "oops, we can't
> actually *map* those pages"?

Steven tested on his setup.

I tested some Infiniband cards.

Thanks

Yinghai
