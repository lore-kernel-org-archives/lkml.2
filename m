Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1JKOWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:22:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58131 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab1JKOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <1318246879-28013-1-git-send-email-richard@nod.at>
References: <1318246879-28013-1-git-send-email-richard@nod.at>
Date: Tue, 11 Oct 2011 22:22:28 +0800
Message-ID: <CAM_iQpWJPHWJJPaMu4Zr-ePx-PCBGsM=S1gODN1Mr0mtk7cSbw@mail.gmail.com>
Subject: Re: [PATCH v3] ramfs: Remove module leftovers
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, dchinner@redhat.com,
        hch@lst.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 7:41 PM, Richard Weinberger <richard@nod.at> wrote:
> Since ramfs is hard-selected to "y", the module leftovers make
> no sense.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Looks good,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
