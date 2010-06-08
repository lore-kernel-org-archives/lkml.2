Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0FHMxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:53:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58329 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0FHMxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:53:44 -0400
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org, miklos@szeredi.hu, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-reply-to: <201006081443.59559.a.miskiewicz@gmail.com> (message from
	Arkadiusz Miskiewicz on Tue, 8 Jun 2010 14:43:58 +0200)
Subject: Re: [ANNOUNCE] util-linux-ng v2.18-rc1
References: <20100608104618.GA18342@nb.net.home> <E1OLwWP-0003Wp-ST@pomaz-ex.szeredi.hu> <201006081443.59559.a.miskiewicz@gmail.com>
Message-Id: <E1OLyJI-0003kh-Hn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jun 2010 14:53:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, Arkadiusz Miskiewicz wrote:
> On Tuesday 08 of June 2010, Miklos Szeredi wrote:
> > On Tue, 8 Jun 2010, Karel Zak wrote:
> > > umount(8):
> > >   - supports new command line option "-f/--fake" to avoid umount(2)
> > >   syscall
> > 
> > I think you just mean "--fake",  -f is --force.
> 
> It's usually called --dry-run, --fake is uncommon.

For mount(8) and umount(8) --fake has a different function from
--dry-run, as it does modify /etc/mtab.

Thanks,
Miklos
