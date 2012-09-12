Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab2ILSt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:49:59 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38054 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2ILSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:49:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <87har6kmfx.fsf@devron.myhome.or.jp>
	<CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
	<87oblc4u6f.fsf@devron.myhome.or.jp>
	<CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
	<871ui84l4l.fsf@devron.myhome.or.jp>
	<CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
	<20120912143227.GE3009@fieldses.org>
	<87vcfjfa14.fsf@devron.myhome.or.jp>
	<20120912171128.GG3009@fieldses.org>
	<87r4q7f8fw.fsf@devron.myhome.or.jp>
	<20120912174556.GH3009@fieldses.org>
Date: Thu, 13 Sep 2012 03:49:52 +0900
In-Reply-To: <20120912174556.GH3009@fieldses.org> (J. Bruce Fields's message
	of "Wed, 12 Sep 2012 13:45:56 -0400")
Message-ID: <87ipbjf54f.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> As another server-side workaround: maybe they could try tuning the inode
> caching to make eviction less likely?
>
> Grepping around...  Documentation/sysctl/vm.txt mentions a
> vfs_cache_pressure parameter.

Yeah. And dirty hack will be possible to adjust sb->s_shrink.batch.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
