Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab0FEJGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 05:06:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:34055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab0FEJGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 05:06:04 -0400
Message-ID: <4C0A1369.9010601@kernel.org>
Date: Sat, 05 Jun 2010 11:05:45 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mikael Bouillot <hmajxxlh@corbac.com>
CC: Miklos Szeredi <mszeredi@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
       fuse-devel@lists.sourceforge.net
Subject: Re: OSS Proxy Jack slave
References: <20100601092456.GA23572@alia.nute.net> <4C066CF4.2050902@gmail.com> <20100605085045.GA5630@alia.nute.net>
In-Reply-To: <20100605085045.GA5630@alia.nute.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 05 Jun 2010 09:05:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Miklos and mailing lists)

On 06/05/2010 10:50 AM, Mikael Bouillot wrote:
> Just a quick question: have you reached some form of understanding
> with Miklos Szeredi over the direct mmap in FUSE issue?
> 
> I've read the thread from February 2010, and though most of the
> kernel material fly way over my head, I've got the general idea.
> 
> FUSD has had mmap support since around the time I started using
> oss2jack, so I don't know exactly how many apps I use require it
> (besides Quake3). I'll put a printf in my oss2jack's mmap() to
> see what I'll be missing.
> 
> I could use a patched FUSE, but stopping to have to maintain a
> piece of out-of-tree kernel code was The. Whole. Point. of
> switching from FUSD to a CUSE-based system T_T

Miklos, any update on the mmap interface?

Thanks.

-- 
tejun
