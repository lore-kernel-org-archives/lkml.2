Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1GJQQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:16:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51080 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1GJQQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
Date: Mon, 11 Jul 2011 00:16:11 +0800
Message-ID: <CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 12:24 AM, Raghavendra D Prabhu
<rprabhu@wnohang.net> wrote:
> Hi,
>    I am seeing Wunused-but-set warning while make nconfig.  Looks like
>    active_menu is not used. Removing it fixes the warning.
>
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
