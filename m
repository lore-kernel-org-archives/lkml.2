Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2K1Uzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:55:33 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38196 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab2K1Uzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:55:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121128175544.4266260d@redhat.com>
References: <CALF0-+XH4AfJUcNHXdMTwXf-=f24Zpe3VOw_1eQ9WBV1-6ZVjQ@mail.gmail.com>
	<CALF0-+USC6ButEO0pMRPFj8hGtL90wi3FrxL-BkE1oF42qcggg@mail.gmail.com>
	<20121128175544.4266260d@redhat.com>
Date: Wed, 28 Nov 2012 17:55:30 -0300
Message-ID: <CALF0-+UkZi5OwwTdE=U+-iudLFJuQQpuXAuXBk=dStoCSss0YQ@mail.gmail.com>
Subject: Re: [PATCH 0/23] media: Replace memcpy with struct assignment
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 4:55 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
[...]
>
> There are 400+ patches pending today at patchwork. I doubt I'll have enough
> time for all of them, so, I'll skip cleanup patches like the above, in order
> to try to focus on bug fixes and patches that brings new functionality to
> existing code and with a low risk of breaking anything.
>

I understand completely.


> Next year, we'll start implementing the sub-maintainers, and, with their
> help, I suspect we'll be able to finally apply those patches.
>
> If you want us to help, feel free to review/test the individual patches
> submitted by non-maintainers to the ML. We tend to apply faster patches
> that are more reviewed.
>
> Hmm... well, actually it is just the opposite: we explicitly delay
> not-reviewed patches for unmaintained/bad maintained drivers,
> to see if someone acks or nacks them after testing.
>

I'll try to help whenever possible.

Thanks,

    Ezequiel
