Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2GFFxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:53:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38585 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2GFFxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:53:51 -0400
Message-ID: <4FF67D6A.8060707@gmail.com>
Date: Fri, 06 Jul 2012 13:53:46 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/5] fuse: make maximum read/write request size tunable
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 06:50 PM, Mitsuo Hayasaka wrote:
> One of the ways to solve this is to make them tunable.
> In this series, the new sysfs parameter max_pages_per_req is introduced.
> It limits the maximum read/write size in fuse request and it can be
> changed from 32 to 256 pages in current implementations. When the
> max_read/max_write mount option is specified, FUSE request size is set
> per mount. (The size is rounded-up to page size and limited up to
> max_pages_per_req.)

Why maxim 256 pages? If we are here, we can go further: most of object
storage system has object size of multiple to dozens of megabytes. So I
think probably 1M is too small. Our distribution storage system has 4M
per object, so I think at least maxim size could be bigger than 4M.

Thanks,
Yuan

