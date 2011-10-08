Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1JHNgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 09:36:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53693 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1JHNgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 09:36:47 -0400
References: <4E8FE4E5.9040606@russia.ru>
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
In-Reply-To: <4E8FE4E5.9040606@russia.ru>
Mime-Version: 1.0 (iPhone Mail 8J2)
Date: Sat, 8 Oct 2011 09:36:42 -0400
Message-ID: <5617831734450003872@unknownmsgid>
Subject: Re: BUG: spinlock lockup while performing FS operations and detected
 stalls on CPUs / tasks.
To: =?UTF-8?B?0JLQsNC70LXRgNC40Lk=?= <paramonov@russia.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "duaneg@dghda.com" <duaneg@dghda.com>,
        Alexander Beregalov <a.beregalov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As soon as smart says there are ANY problem, the disk IS going bad and
will have serious problem soon enough. Especially READ DMA errors
which mean it reallocate sectors. Consumer level disk try to hide
problems as hard as they can until the disk finally fail. Try ddrescue
from disk to /dev/null to check for speed, I guess it is slow.

Envoyé de mon appareil mobile.

Jérôme Poulin
Solutions G.A.

On 2011-10-08, at 01:52, Валерий <paramonov@russia.ru> wrote:

> So, this IDE drive has non-critical SMART errors listed at end of message by command smartctl --all /dev/sde. It is unclear how this might affect the command dd.
