Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1H3O3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:29:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61781 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab1H3O3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:29:33 -0400
MIME-Version: 1.0
In-Reply-To: <1314631491-27095-1-git-send-email-richard@nod.at>
References: <1314631491-27095-1-git-send-email-richard@nod.at>
Date: Tue, 30 Aug 2011 22:29:32 +0800
Message-ID: <CAM_iQpXWaYbooV_BX+ix8DzayFwhaACQTnwjbTuqmEV0fGU3=w@mail.gmail.com>
Subject: Re: [PATCH] ramfs: Remove module leftovers
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, dchinner@redhat.com,
        hch@lst.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:24 PM, Richard Weinberger <richard@nod.at> wrote:
> Since ramfs is hard-selected to "y", the module leftovers make
> no sense.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Yeah, it makes sense to remove these module stuffs,
but I think there is no need to make exit_ramfs_fs()
be an __exit_call, so just remove exit_ramfs_fs()?

Thanks.
