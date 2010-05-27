Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0E0MsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:48:11 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36832 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0E0MsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:48:09 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, john.johansen@canonical.com,
       penguin-kernel@i-love.sakura.ne.jp, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <AANLkTilGlR297cl9yHF5n6e4eU7JflJwrpm3TrIe-rlo@mail.gmail.com>
	(message from Alexey Dobriyan on Thu, 27 May 2010 15:30:34 +0300)
Subject: Re: [PATCH 1/2] vfs: sanitize __d_path()
References: <E1OHaLJ-0008VD-VJ@pomaz-ex.szeredi.hu> <AANLkTilGlR297cl9yHF5n6e4eU7JflJwrpm3TrIe-rlo@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1OHcV6-0000oz-C5@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 May 2010 14:47:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alexey Dobriyan wrote:
> On Thu, May 27, 2010 at 1:29 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > __d_path() no longer appends " (deleted)" to unlinked paths.  This is
> > moved into d_path() which is the only caller that cares.
> 
> d_path() or equivalent should get "int *deleted" argument to distinguish
> really deleted files. Then users can decide if they care or not.

Why can't they distinguish deleted files by just calling d_unlinked()?

Thanks,
Miklos
