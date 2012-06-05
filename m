Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825Ab2FEKtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:49:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44674 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761718Ab2FEKtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:49:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FCDE2ED.8010501@gmx.de>
References: <4FCD28E4.3090409@gmx.de>
	<4FCDE2ED.8010501@gmx.de>
Date: Tue, 5 Jun 2012 12:49:12 +0200
Message-ID: <CAFLxGvyNsJuavwsom_h14JJu7RBRhfs0AT85GftfRDCv8PrBWA@mail.gmail.com>
Subject: Re: commit 0fc9d10 : chroot under kernel 3.4.x core dumps
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 12:43 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> In the rare cases, where the chroot doesn't crash, all subsequent
> commands cores instead. Furthermore it seems, that the boinc grid
> software has problems too under kernel 3.4.1.
> All kernel 3.3.x works fine.
>
> I bisected it to :
>
> commit 0fc9d1040313047edf6a39fd4d7c7defdca97c62
> Author: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Date:   Wed Mar 28 14:42:54 2012 -0700
>
>    radix-tree: use iterators in find_get_pages* functions

After reverting commit 0fc9d1 chroot() works fine again?
(Just to make sure that the bisect is valid)

-- 
Thanks,
//richard
