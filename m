Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1BXA3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:29:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763Ab1BXA3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:29:22 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
 <20110222140349.GA20708@kryptos.osrc.amd.com> <AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
 <AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
 <AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com> <AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Feb 2011 16:28:31 -0800
Message-ID: <AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 9:16 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>>
>> Looks like nouveafb took over from vesafb. Did you do anything special
>> to trigger this?
>
> No. Just boot the system.

Every boot?

And just out of interest, what happens if you don't have the vesafb
driver at all?

                          Linus
