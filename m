Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab0HDOzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:55:47 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52088 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0HDOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:55:46 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, miklos@szeredi.hu, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vaurora@redhat.com
In-reply-to: <1276627208-17242-22-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Tue, 15 Jun 2010 11:39:51 -0700)
Subject: Re: [PATCH 21/38] union-mount: Support for mounting union mount file systems
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-22-git-send-email-vaurora@redhat.com>
Message-Id: <E1OgfNb-0000ok-7p@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Aug 2010 16:55:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010, Valerie Aurora wrote:
> Create and tear down union mount structures on mount.  Check
> requirements for union mounts.  This version clones the read-only
> mounts and puts them in an array hanging off the superblock of the
> topmost layer.

If I do

  mount -r fs1 /mnt
  mount -r fs2 /mnt
  mount -ounion fs3 /mnt

then only fs2 and fs3 will be unioned.

Or how are multiple read-only layers supposed to work?

Miklos
