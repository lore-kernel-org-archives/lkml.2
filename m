Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2DNN5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 09:57:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58959 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2DNN5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 09:57:17 -0400
Message-ID: <1334411697.2200.20.camel@brekeke>
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sat, 14 Apr 2012 16:54:57 +0300
In-Reply-To: <87y5pyfoe0.fsf@devron.myhome.or.jp>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	 <1334326795-2446-5-git-send-email-dedekind1@gmail.com>
	 <87fwc6hazv.fsf@devron.myhome.or.jp> <1334399379.2263.8.camel@koala>
	 <87bomuha77.fsf@devron.myhome.or.jp> <1334401307.2263.24.camel@koala>
	 <873986h6qa.fsf@devron.myhome.or.jp> <1334406974.2263.38.camel@koala>
	 <87y5pyfoe0.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 22:12 +0900, OGAWA Hirofumi wrote:
> Hm, you want to this one?
> 
> If fsinfo is inode, the order can be
> 
> 1) flush inodes
>     1a) flush fsinfo inode
>     1b) flush normal inodes
> 2) last iput(normal inodes)
>       truncate()
>            dirty fsinfo inode

Clear, thanks, I'll look at this.

Artem.

