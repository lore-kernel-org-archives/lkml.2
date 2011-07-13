Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab1GMLjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:39:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915Ab1GMLjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:39:32 -0400
Date: Wed, 13 Jul 2011 13:39:30 +0200
From: Michal Marek <mmarek@suse.cz>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kbuild@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid Wunused-but-set warning
Message-ID: <20110713113930.GC25895@sepie.suse.cz>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
 <CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:16:11AM +0800, Américo Wang wrote:
> On Sun, Jul 10, 2011 at 12:24 AM, Raghavendra D Prabhu
> <rprabhu@wnohang.net> wrote:
> > Hi,
> >    I am seeing Wunused-but-set warning while make nconfig.  Looks like
> >    active_menu is not used. Removing it fixes the warning.
> >
> > Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Applied as "nconfig: Avoid Wunused-but-set warning" to
kbuild-2.6.git#kconfig. Raghavendra, please use the "subsystem: Fix this
and that" format of the subject line next time, thanks.

Now continue your fruitful discussion.

Michal
