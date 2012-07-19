Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2GSRwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:52:10 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36990 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2GSRwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:52:05 -0400
Message-ID: <5008493C.7030602@landley.net>
Date: Thu, 19 Jul 2012 12:51:56 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muthukumar R <muthur@gmail.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Nikolaus Rath <Nikolaus@rath.org>, Liu Yuan <namei.unix@gmail.com>,
        Has-Wen Nienhuys <hanwen@xs4all.nl>
Subject: Re: [PATCH -v2 6/6] fuse: add documentation of sysfs parameter to
 limit maximum fuse request size
References: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp> <20120719125007.6250.29754.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120719125007.6250.29754.stgit@ltc137.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 07:50 AM, Mitsuo Hayasaka wrote:
> Add an explanation about the sysfs parameter to limit the
> maximum read/write request size.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Nikolaus Rath <Nikolaus@rath.org>
> Cc: Liu Yuan <namei.unix@gmail.com>
> Cc: Has-Wen Nienhuys <hanwen@xs4all.nl>
> ---

Acked-by: Rob Landley <rob@landley.net>

I'll forward it along next merge window if nobody else grabs it first.

Thanks,

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
