Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab1KIJJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:09:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60574 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab1KIJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:09:34 -0500
MIME-Version: 1.0
In-Reply-To: <4EBA40E3.60203@metafoo.de>
References: <4EBA40E3.60203@metafoo.de>
Date: Wed, 9 Nov 2011 17:09:33 +0800
Message-ID: <CAA_GA1c-XAT4DjTfRdwqc4gVZQkC3hZ2PDGZ-W3GMajwYx2ALA@mail.gmail.com>
Subject: Re: What happened to vcoalesce?
From: Bob Liu <lliubbo@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 9, 2011 at 4:59 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> Hi Mike,
>
> I'm using the kernel firmware loader on a blackfin board. And this currently
> doesn't work with mainline since the firmware loader uses vmap. In the ADI
> blackfin Linux tree there is a patch written by you, which fixes this.
>
> What is the status of that patch in regard to going mainline? I found a
> mailing-list post from January where you tried to submit it upstream, but
> there was a minor bug in the patch and so the it was rejected. In March you
> posted the fixed up version and from than on I couldn't find references to
> it anymore.
>

This may be help .

https://lkml.org/lkml/2011/1/12/2
https://lkml.org/lkml/2011/3/28/46

-- 
Regards,
--Bob
