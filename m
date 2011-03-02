Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1CBPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:16:29 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:52871 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1CBPQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:16:28 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, t.artem@mailcity.com,
        Roman Zippel <zippel@linux-m68k.org>
Subject: Re: MS_SILENT vs. vfat and hfs
References: <20110302114517.GA496@nb.net.home>
	<87d3m9r4mz.fsf@devron.myhome.or.jp>
	<20110302144303.GC14636@nb.net.home>
	<20110302150607.GD14636@nb.net.home>
Date: Thu, 03 Mar 2011 00:16:25 +0900
In-Reply-To: <20110302150607.GD14636@nb.net.home> (Karel Zak's message of
	"Wed, 2 Mar 2011 16:06:07 +0100")
Message-ID: <87vd01pn7a.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak <kzak@redhat.com> writes:

>  I'll probably add an exception for vfat and hfs to mount(8), "silent"
>  as MS_SILENT and mark "quiet" as deprecated for non-fat filesystems.

Sounds really good to me.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
