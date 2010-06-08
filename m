Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0FHK7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 06:59:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57754 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0FHK7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 06:59:11 -0400
To: Karel Zak <kzak@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
In-reply-to: <20100608104618.GA18342@nb.net.home> (message from Karel Zak on
	Tue, 8 Jun 2010 12:46:18 +0200)
Subject: Re: [ANNOUNCE] util-linux-ng v2.18-rc1
References: <20100608104618.GA18342@nb.net.home>
Message-Id: <E1OLwWP-0003Wp-ST@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jun 2010 12:59:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, Karel Zak wrote:
> umount(8):
>   - supports new command line option "-f/--fake" to avoid umount(2) syscall

I think you just mean "--fake",  -f is --force.

Thanks,
Miklos
